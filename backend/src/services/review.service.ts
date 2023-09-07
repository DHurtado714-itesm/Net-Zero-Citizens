import { Review, ReviewModel } from "../models/review.model";
import { PaginationParams, PaginatedQuery } from "../utils/RequestResponse";

export const getAllReviews = async<T>(
    params: PaginationParams<T>
): Promise<PaginatedQuery<Review>> => {
    return await ReviewModel.findAndCountAll({
        limit: params.pageSize,
        offset: params.start,
    })
}