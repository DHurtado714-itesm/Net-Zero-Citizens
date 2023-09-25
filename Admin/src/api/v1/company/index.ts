import { authAxios } from '../axios.config'

export interface Company {
  companyId: string
  name: string
  profilePicture: string
  state: string
  city: string
  street: string
  zipCode: string
  status: 'approved' | 'pending_approval' | 'rejected'
  email: string
  phone: string
  webPage: string
  description: string
  createdAt: string
  streetNumber: string
  pdfCurriculumUrl: string
  pdfDicCdmxUrl: string
  pdfPeeFideUrl: string
  pdfGuaranteeSecurityUrl: string
  pdfActaConstitutivaUrl: string
  pdfIneUrl: string
}

type StatusEnum = 'approved' | 'pending_approval' | 'rejected'

/**
 * @brief
 * Funcion que regresa los proveedores del status especificado
 * @param status
 * @returns Una respuesta conteniendo todos los proveedores pendientes
 */
export const getComapniesByStatus = async (status: StatusEnum) => {
  try {
    if (status === 'pending_approval') {
      const response = await authAxios().get('/company/pending')
      return response.data.rows
    } else {
      const response = await authAxios().get('/company/approved')
      return response.data.rows
    }
  } catch (error) {
    console.error('Error fetching pending companies:', error)
    throw error
  }
}

export type UpdateCompanyInfoBody = {
  name: string
  description: string
  street: string
  streetNumber: string
  city: string
  state: string
  zipCode: string
  profilePicture: string
  status: 'approved' | 'pending_approval' | 'rejected'
  phone: string
  webPage: string
}

/**
 * @brief Actualiza la información de un proveedor
 * @param companyId
 * @param updateInfo
 * @returns
 */

export const updateCompany = async (
  companyId: string,
  updateInfo: UpdateCompanyInfoBody
) => {
  try {
    const response = await authAxios().post(
      `/company/pending/${companyId}`,
      updateInfo
    )
    return response.data
  } catch (error) {
    console.error('Error updating company:', error)
    throw error
  }
}
