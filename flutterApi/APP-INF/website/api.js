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
            q.query.bool.must.push({
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

        var products = formatter.newArrayList();

        if (formatter.isNotNull(results)) {
            var hits = results.hits.hits;
            for (var i = 0; i < hits.length; i++) {
                var hit = hits[i];
                var productSource = hit.sourceAsMap;

                if (formatter.isNotEmpty(productSource.skus)) {
                    for (var psi = 0; psi < productSource.skus.size(); psi++) {
                        var skuMap = productSource.skus.get(psi);

                        var sku = services.catalogManager.findSku(skuMap.skuCode);

                        if (formatter.isNotNull(sku)) {
                            skuMap.skuId = sku.id;
                        }
                    }

                    log.info('Skus :: {}', productSource.skus);
                }

                products.add(productSource);
            }
        }

        var jr = views.jsonResult(true);
        jr.data = products;

        return jr;
    };

    g._getCategories = function (page) {
        var fc = formatter.newFormContext();

        var storeName = fc.rawParam('storeName');
        var storeObj = services.catalogManager.findStore(storeName);

        var results = formatter.newArrayList();

        var ecomApp = applications.get('KCommerce2');
        var categories = ecomApp.call('getCategoriesInStore', storeObj, null);

        if (formatter.isNotEmpty(categories)) {

            categories.forEach(function (m) {
                var cat = m.category;
                if (!cat.hidden) {
                    var catMap = formatter.newMap();

                    catMap.put('id', cat.id);
                    catMap.put('name', cat.name);
                    catMap.put('title', cat.title);
                    if (formatter.isNotNull(cat.mainImageHash)) {
                        catMap.put('mainImageHash', '/_hashes/files/' + cat.mainImageHash);
                    } else {
                        catMap.put('mainImageHash', null);
                    }

                    results.add(catMap);
                }
            });
        }

        var jr = views.jsonResult(true);
        jr.data = results;

        return jr;
    };

    g._getCart = function (page) {
        var fc = formatter.newFormContext();
        var data = formatter.newMap();

        var storeName = fc.rawParam('storeName');
        var storeObj = services.catalogManager.findStore(storeName);
        var cart = services.cartManager.shoppingCart(false);

        if (formatter.isNotNull(storeObj) && formatter.isNotNull(cart)) {
            var checkoutItems = services.cartManager.checkoutItems(cart, storeObj);
            var cartMap = formatter.newMap();

            cartMap.numItems = checkoutItems.numItems;
            cartMap.cartId = checkoutItems.cartId;
            cartMap.totalCost = checkoutItems.totalCost;

            var lineItems = formatter.newArrayList();
            cartMap.lineItems = lineItems;

            for (var i = 0; i < checkoutItems.items.size(); i++) {
                var lineItem = checkoutItems.items.get(i);

                var lineItemMap = formatter.newMap();
                lineItemMap.itemId = lineItem.lineItemId;
                lineItemMap.quantity = lineItem.quantity;
                lineItemMap.unitCost = lineItem.unitCost;
                lineItemMap.taxRate = lineItem.taxRate;
                lineItemMap.tax = lineItem.tax;
                lineItemMap.finalCost = lineItem.finalCost;
                lineItemMap.itemDescription = lineItem.itemDescription;

                if (formatter.isNotNull(lineItem.productSku)) {
                    var productSku = formatter.newMap();
                    productSku.id = lineItem.productSku.id;
                    productSku.name = lineItem.productSku.name;
                    productSku.title = lineItem.productSku.title;
                    productSku.imageHash = lineItem.productSku.imageHash;

                    lineItemMap.productSku = productSku;
                }

                if (formatter.isNotNull(lineItem.product)) {
                    var product = formatter.newMap();

                    var productImages = lineItem.product.images;
                    if (formatter.isNotEmpty(productImages)) {
                        var images = formatter.newArrayList();
                        product.images = images;
                        for (var ii = 0; ii < productImages.size(); ii++) {
                            var image = productImages.get(ii);
                            images.add(image);
                        }
                    }

                    lineItemMap.product = product;
                }

                lineItems.add(lineItemMap);
            }

            data.put('cart', cartMap);
        }

        var pointsBucketName = fc.rawParam('pointsBucket');
        var pointsBucket = services.pointsManager.findPointsBucket(pointsBucketName);

        if (formatter.isNotNull(pointsBucket)) {
            var curUser = securityManager.currentProfile;
            var pointsBalance = services.pointsManager.availableBalance(curUser, pointsBucket);
            data.put('pointsBalance', pointsBalance);
        }

        var jr = views.jsonResult(true);
        jr.data = data;

        return jr;
    };
})(this);