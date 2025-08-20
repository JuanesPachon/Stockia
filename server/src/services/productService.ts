import { ICreateAndEditResult, IDeleteResult, IGetResult } from "../interfaces/database.interface.js";
import { IProduct } from "../interfaces/models.interface.js";
import Product from "../models/productModel.js";
import User from "../models/userModel.js";

const createProduct = async (productData: IProduct, userId: string): Promise<ICreateAndEditResult> => {

    try {

        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        const existingProduct = await Product.exists({
            name: productData.name,
        });

        if (existingProduct) {
            return {
                success: false,
                error: 'duplicate',
                message: 'Product already exists',
            };
        }

        const newProduct = {
            ...productData,
            userId: userId,
        };

        await Product.create(newProduct);

        return {
            success: true,
            message: 'Product created successfully',
            data: {
                name: newProduct.name,
                price: newProduct.price,
                stock: newProduct.stock,
            },
        };
    } catch (error) {
        console.error('Error creating product:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while creating the product',
        };
    }

}

const getProducts = async (userId: string, order: string = 'desc', categoryId?: string): Promise<IGetResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
                message: 'User not found',
            };
        }

        const sortOrder = order === 'asc' ? 1 : -1;
        const sortObject: any = {};
        sortObject['createdAt'] = sortOrder;

        const filters: any = { 
            userId: userId, 
            deletedAt: null 
        };

        if (categoryId) {
            filters.categoryId = categoryId;
        }

        const products = await Product.find(filters)
            .sort(sortObject)
            .populate({
                path: 'categoryId',
                select: 'name',
                match: { _id: { $ne: null } }
            })
            .populate({
                path: 'providerId', 
                select: 'name',
                match: { _id: { $ne: null } }
            });

        return {
            success: true,
            message: 'Products retrieved successfully',
            data: products,
        };
    } catch (error) {
        console.error('Error fetching products:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the products',
        };
    }
};

const getProductById = async (productId: string, userId: string): Promise<IGetResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const product = await Product.findOne({
            _id: productId,
            userId: userId,
            deletedAt: null,
        })
        .populate({
            path: 'categoryId',
            select: 'name description',
            match: { _id: { $ne: null } }
        })
        .populate({
            path: 'providerId',
            select: 'name',
            match: { _id: { $ne: null } }
        });

        if (!product) {
            return {
                success: false,
                error: 'not_found',
                message: 'Product not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Product retrieved successfully',
            data: product,
        };
    } catch (error) {
        console.error('Error fetching product:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the product',
        };
    }
};

const updateProduct = async (productId: string, productData: IProduct, userId: string): Promise<ICreateAndEditResult> => {

    try {

        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        const updatedProduct = await Product.findOneAndUpdate(
            { _id: productId, userId: userId },
            productData,
            { new: true }
        );

        if (!updatedProduct) {
            return {
                success: false,
                error: 'not_found',
                message: 'Product not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Product updated successfully',
            data: {
                name: updatedProduct.name,
                price: updatedProduct.price,
                stock: updatedProduct.stock,
            },
        };
    } catch (error: any) {
        console.error('Error updating product:', error);

        if (error.code === 11000 && error.codeName === 'DuplicateKey') {
            return {
                success: false,
                error: 'duplicate',
                message: 'Product with this name already exists for this user',
            };
        }

        return {
            success: false,
            error: 'server',
            message: 'An error occurred while updating the product',
        };
    }

}

const deleteProduct = async (productId: string, userId: string): Promise<IDeleteResult> => {
    try {

        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const deletedProduct = await Product.findOneAndUpdate(
            {
                _id: productId,
                userId: userId,
            },
            {
                deletedAt: new Date(),
            }
        );

        if (!deletedProduct) {
            return {
                success: false,
                error: 'not_found',
                message: 'Product not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Product deleted successfully',
        };
    } catch (error) {
        console.error('Error deleting product:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while deleting the product',
        };
    }
};

export default {
    getProducts,
    getProductById,
    createProduct,
    updateProduct,
    deleteProduct,
}