import { ICreateResult } from '../interfaces/database.interface.js';
import { ICategory } from '../interfaces/models.interface.js';
import Category from '../models/categoryModel.js';
import User from '../models/userModel.js';
import mongoose from 'mongoose';

const createCategory = async (categoryData: ICategory, userId: string): Promise<ICreateResult> => {
    try {
        if (!mongoose.isValidObjectId(userId)) {
            return {
                success: false,
                error: 'server',
                message: 'Invalid user ID format',
            };
        }

        const userObjectId = new mongoose.Types.ObjectId(userId);
        
        const existingUser = await User.exists({ _id: userObjectId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        const existingCategory = await Category.exists({ 
            name: categoryData.name
        });
        
        if (existingCategory) {
            return {
                success: false,
                error: 'duplicate',
                message: 'Category already exists',
            };
        }

        const newCategory = {
            ...categoryData,
            userId: userObjectId,
        };

        await Category.create(newCategory);

        return {
            success: true,
            message: 'Category created successfully',
            data: {
                name: newCategory.name,
                description: newCategory.description,
            }
        };
    } catch (error) {
        console.error('Error creating category:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while creating the category',
        };
    }
};

export default {
    createCategory
};
