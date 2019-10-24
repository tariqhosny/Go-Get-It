//
//  confige.swift
//  Go Get It
//
//  Created by Tariq on 9/29/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import Foundation

struct URLs {
    static let baseURL = "http://creativityvein.com/api/"
    //main
    static let file_root = "http://creativityvein.com"
    //post login(email, password)
    static let login = baseURL + "login"
    //post register(name, phone, email, password)
    static let register = baseURL + "register"
    //post slider(lang, haeder)
    static let slider = baseURL + "slider"
    //post latest_product(lang)
    static let latestProduct = baseURL + "latest_products"
    //post feature_products(lang)
    static let featureProducts = baseURL + "feature_products"
    //post categories(lang)
    static let categories = baseURL + "categories"
    //post brands(lang)
    static let brands = baseURL + "brands"
    //post products(category_id, brand_id, lang)
    static let products = baseURL + "products"
    //post productImages(id)
    static let productImages = baseURL + "products_images"
    //post productColors(id)
    static let productColor = baseURL + "products_colors"
    //post addCart(product_id)
    static let addCart = baseURL + "add_cart"
    //post list_data_cart(lang)
    static let cartList = baseURL + "list_data_cart"
    //post plus_quentity_Cart(lang, cart_id)
    static let plusCart = baseURL + "plus_quentity_Cart"
    //post min_quentity_Cart(lang, cart_id)
    static let minCart = baseURL + "min_quentity_Cart"
    //post favorite_product(lang, product_id)
    static let favorite = baseURL + "favorite_product"
    //post list_favorite_product(lang)
    static let favoriteList = baseURL + "list_favorite_product"
    //post delete_cart(lang, cart_id)
    static let deleteCart = baseURL + "delete_cart"
    //post create_order(..)
    static let createOrder = baseURL + "create_order"
    //post order_list(lang)
    static let orderList = baseURL + "order_list"
    //post order_list_details(order_id)
    static let orderDetails = baseURL + "order_list_details"
    //post rate_list(product_id)
    static let rateList = baseURL + "rate_list"
    //post create_rate(productID, rateRange, comment)
    static let createRate = baseURL + "rate_creat"
    //post profile()
    static let profile = baseURL + "user_profile"
    //post update_profile(phone, name, email, password)
    static let updateProfile = baseURL + "update_profile"
    //all products(lang)
    static let allProducts = baseURL + "all_products"
    //post privacies(lang)
    static let privacies = baseURL + "privacies"
    //post sizes()
    static let sizes = baseURL + "products_size"
    //post filters_all_sizes
    static let allSizes = baseURL + "filters_all_sizes"
    //post fillter_search_all_products
    static let filter = baseURL + "fillter_search_all_products"
    //post products_category
    static let products_category = baseURL + "products_category"
    //similar_products
    static let similar_products = baseURL + "similar_products"
    //change_password
    static let change_password = baseURL + "change_password"
}
