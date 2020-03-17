(function (g) {
    g._getProducts = function (page) {
        var fc = formatter.newFormContext();

        var queryString = fc.rawParam('q');
        var storeName = fc.rawParam('storeName');
        var categoryName = fc.rawParam('categoryName');

        var storeObj = services.catalogManager.findStore(storeName);
        var categoryObj = services.catalogManager.findCategory(categoryName);

        var q = {
            _source: true,
            query: {
                bool: {
                    must: [
                        { term: { storeId: storeObj.id } }
                    ]
                }
            }
        };

        // category is also used in the brand attribute, so match on either
        if (categoryObj !== null && !categoryObj.hidden) {
            must.push({
                bool: {
                    should: [
                        { term: { 'categoryIds': categoryObj.id } },
                        { term: { 'brandId': categoryObj.id } }
                    ]
                }
            });
        }

        if (formatter.isNotNull(queryString)) {
            var shoulds = {
                bool: {
                    should: []
                }
            };

            shoulds.bool.should.push({
                multi_match: {
                    query: queryString,
                    fields: ['name^2', 'title^2', 'tags', 'productCode^3', 'brief^2', 'brandName^3', 'content'],
                    type: 'phrase_prefix'
                }
            });

            shoulds.bool.should.push({
                multi_match: {
                    query: queryString,
                    fields: ['name^2', 'title^2', 'tags', 'productCode^3', 'brief^2', 'brandName^3', 'content'],
                    type: 'most_fields'
                }
            });

            shoulds.bool.should.push({
                prefix: { name: { value: queryString, boost: 5.0 } }
            });

            q.query.bool.must.push(shoulds);
        }

        var results = services.searchManager.search(JSON.stringify(q), 'ecommercestore');

        var data = formatter.newMap();
        var products = formatter.newArrayList();
        data.put('products', products);

        if (formatter.isNotNull(results)) {
            var hits = results.hits.hits;
            for (var i = 0; i < hits.length; i++) {
                var hit = hits[i];
                products.add(hit.sourceAsMap);
            }
        }

        var jr = views.jsonResult(true);
        jr.data = data;

        return jr;
    };

    g._getCategories = function (page) {
        var fc = formatter.newFormContext();
    };

    g._getPoints = function (page) {
        var fc = formatter.newFormContext();
    };
})(this);