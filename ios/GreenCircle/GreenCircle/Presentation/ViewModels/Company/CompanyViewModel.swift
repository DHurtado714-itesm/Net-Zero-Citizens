//
//  CompanyViewModel.swift
//  GreenCircle
//
//  Created by Dani Gutiérrez on 06/09/23.
//

import Foundation

/// Implementación de view model de modelo de Compañía
class CompanyViewModel: ObservableObject {
  /// Caso de uso para hacer fetch de los datos de compañía
  private let useCase: CompanyUseCase
  private let repository: CompanyRepository
  
  @Published var companies = [Company]()
    
    enum CompanyViewModelError: Error {
        case failedToFetchCompanies
    }

  
  /// La compañía puede cambiar en la vista (se construye .onAppear())
  @Published var contentCompany: Company = Company(
    companyId: UUID(uuidString: "") ?? UUID(),
    userId: "",
    name: "",
    description: "",
    email: "",
    phone: "",
    webPage: "",
    street: "",
    streetNumber: "",
    city: "",
    state: "",
    zipCode: "",
    profilePicture: "",
    status: .approved,
    createdAt: "",
    updatedAt: "",
    products: [],
    score: 0.0,
    oneComment: "",
    images: []
    )
  
  /// Para implementar el caso de uso en la vista que llame al ViewModel Compañía
    init(useCase: CompanyUseCase = CompanyUseCase.shared, repository: CompanyRepository = CompanyRepository.shared) {
        self.useCase = useCase
        self.repository = repository
    }
  
  @MainActor
  /// Obtener información de la compañía mediante el caso de uso
  /// Actualización de la compañía si existe el UUID en base de datos
  func fetchCompanyById(idCompany: UUID) async {
    let resultCompany = await useCase.fetchCompanyById(id: idCompany)
    if let resultCompany = resultCompany {
        contentCompany = resultCompany
    }
  }
  
    @MainActor
    func fetchAllCompanies() async throws {
        guard let fetchedCompanies = await useCase.fetchAllCompanies() else {
            throw CompanyViewModelError.failedToFetchCompanies
        }
        self.companies = fetchedCompanies.rows
    }
    
    @MainActor
    func uploadFile(file: Data) async {
        await repository.uploadCompanyFile(file: file)
    }
}
