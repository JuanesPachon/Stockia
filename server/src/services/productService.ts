import { ICreateAndEditResult, IDeleteResult } from "../interfaces/database.interface.js";
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
    createProduct,
    updateProduct,
    deleteProduct,
}