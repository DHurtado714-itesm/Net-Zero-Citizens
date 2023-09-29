//
//  CompanyRepository.swift
//  GreenCircle
//
//  Created by Ricardo Adolfo Fernández Alvarado on 19/09/23.
//  Created by Daniel Gutierresz on 19/09/23.
//

import Foundation

/// Clase representando la estructura de la API para las compañías
class CompanyAPI {
  static let base = "http://localhost:4000/api/v1/company"
  struct Routes {
    static let create = "/create"
    static let company = "/company/"
    static let uploadFile = "/upload/file"
  }
}

struct APIResponse: Codable {
    let message: String
}

/// Protocolo con las funciones del repositorio de Compañías
protocol CompanyRepositoryProtocol {
  func postCompany(company: PostCompanyData) async
  func fetchCompanyById(companyId: UUID) async -> Company?
  //func fetchAllCompanies() async -> Company?
    func uploadCompanyFile(file: Data, fileDescription: String, fileFormat: String, mimeType: String) async -> APIResponse?
}


/// Clase con las funciones del repositorio de las compañías
class CompanyRepository: CompanyRepositoryProtocol {
  /// Inicialización de servicio backEnd
  let service: NetworkAPIService
    let local: LocalService
  /// Inicialización de singleton de repositorio de compañía
  static let shared = CompanyRepository()
  /// Constructor que toma el valor del servicio del backEnd
    init(service: NetworkAPIService = NetworkAPIService.shared, local: LocalService = LocalService.shared) {
    self.service = service
        self.local = local
  }
  
  /// Obtener compañía por UUID llamando al método del servicio del backend
  ///   - Parameters: UUID de la compañía
  ///   - Returns: Modelo de compañía
  func fetchCompanyById(companyId: UUID) async -> Company? {
    return await service
      .getRequest(URL(string:
                        "\(CompanyAPI.base)/\(companyId.uuidString.lowercased())")!)
  }
  
  /// Función que llama al servicio de conexión con la API para postear una  nueva compañía
  /// - Parameters:
  ///   - authToken: token de autenticación
  ///   - company: el objeto con la información de la compañía
  func postCompany(company: PostCompanyData) async {
    let params: [String: Any] = [
      "company": [
        "name": company.name,
        "description": company.description,
        "email": company.email,
        "phone": company.phone,
        "webPage": company.webPage,
        "street": company.street,
        "streetNumber": company.streetNumber,
        "city": company.city,
        "state": company.state,
        "zipCode": company.zipCode,
        "userId": company.userId!,
      ] as [String : Any]
    ]
    let _: NoResponse? = await service
      .postRequest(URL(
        string: "\(CompanyAPI.base)\(CompanyAPI.Routes.create)")!,
                   body: params)
  }
  
    func fetchAllCompanies() async -> PaginatedQuery<Company>? {
    return await service
      .getRequest(URL(string: "\(CompanyAPI.base)")!)
  }
  
    /// Funcion para llamar al servicio de subir archivos
    /// - Parameters:
    ///     - file: el archivo seleccionado
    ///     - fileDescription: La descripcion del archivo es un enun
    ///     - fileFormat: procurar que sea un pdf
    ///     - mimeType: el tipo de archivo para que lo entienda AF

    func uploadCompanyFile(file: Data, fileDescription: String, fileFormat: String, mimeType: String) async -> APIResponse? {
        let uploadURL = URL(string: "\(CompanyAPI.base)\(CompanyAPI.Routes.uploadFile)")!
        let companyId = local.getCompanyId()
        let additionalParameters: [String: Any] = [
            // "companyId": companyId!,
            "companyId": "c1b0e7e0-0b1a-4e1a-9f1a-0e5a9a1b0e7e",
            "fileDescription": fileDescription,
            "fileFormat": fileFormat,
        ]
        let fileName = "archivo.pdf"
        let mimeType = mimeType
        return await service.uploadFileRequest(uploadURL, file: file, fileName: fileName, mimeType: mimeType, additionalParameters: additionalParameters)
    }

}
