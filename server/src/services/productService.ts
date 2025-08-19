import { ICreateAndEditResult } from "../interfaces/database.interface.js";
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

export default {
    createProduct,
}