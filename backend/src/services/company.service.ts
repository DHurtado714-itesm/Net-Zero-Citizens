import CompanyProducts from '../models/companyProducts.model'
import Product from '../models/products.model'
import Review from '../models/review.model'
import Company from '../models/company.model'
import { PaginationParams, PaginatedQuery } from '../utils/RequestResponse'

/**
 * @brief
 * Función del servicio que devuelve todos los proveedores de la base de datos
 * @param params Los parametros de paginación
 * @returns Una promesa con los proveedores y la información de paginación
 */
export const getAllCompanies = async <T>(
  params: PaginationParams<T>
): Promise<PaginatedQuery<Company>> => {
  return Company.findAndCountAll({
    limit: params.pageSize,
    offset: params.start,
  })
}

/**
 * @brief
 * Obtiene un proveedor por su id y lo devuelve en la respuesta
 * @param id Id del proveedor a buscar
 * @returns Promise<Company | Null> Proveedor con el id especificado
 */
export const getCompanyById = async (id: string): Promise<Company | null> => {
  return Company.findOne({
    where: {
      companyId: id,
    }
  })
}

export const getCompanyProductImages = async (id: string): Promise<Company | null> => {
  return Company.findAll({
    where: {
      companyId: id,
    },
    include:[{
      model: CompanyProducts,
      required: true,
      through: {
        attributes: ['productId','companyId']
      },
      where: {
        companyId: id
      },
      include: [{
        model: Product,
        required:true,
        through: {
          attributes: ['productId','name','description','imageUrl','imageAltText']
        }
      },]
    }],
    attributes: {
      exclude: ['userId','name','description','email','phone','street','streetNumber',
                'city','state','zipCode','latitude','longitude','profilePicture',
                'pdfCurriculumUrl','pdfDicCdmxUrl','pdfPeeFideUrl','pdfGuaranteeSecurityUrl',
                'pdfActaConstitutivaUrl','pdfIneUrl','status','products','images'],
      include:['Product.imageUrl','Product.name','Product.description','Product.imageAltText']
    }
  })
}

export const getCompanyScore = async (id: string): Promise<Company | null> => {
  return Company.findAll({
    where: {
      companyId: id,
    },
    include:[{
        model: Review,
        attributes: ['rating']
      }],
    attributes: {
      exclude: ['userId','name','description','email','phone','street','streetNumber',
                'city','state','zipCode','latitude','longitude','profilePicture',
                'pdfCurriculumUrl','pdfDicCdmxUrl','pdfPeeFideUrl','pdfGuaranteeSecurityUrl',
                'pdfActaConstitutivaUrl','pdfIneUrl','status','products','images'],
      include: [[Sequelize.fn('AVG', Sequelize.col('Review.rating')),'rating']],
    },
    group: ['Company.companyId'],
  })
}