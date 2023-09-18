//
//  Products.swift
//  GreenCircle
//
//  Created by Dani Gutiérrez on 07/09/23.
//

import Foundation

struct Product: Codable {
  var productId: UUID
  var name: String
  var description: String?
  var imageUrl: String
  var imageAltText: String
}
