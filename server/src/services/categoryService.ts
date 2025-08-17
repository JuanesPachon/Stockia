import { ICreateAndEditResult, IDeleteResult } from '../interfaces/database.interface.js';
import { ICategory } from '../interfaces/models.interface.js';
import Category from '../models/categoryModel.js';
import User from '../models/userModel.js';
import mongoose from 'mongoose';

const createCategory = async (categoryData: ICategory, userId: string): Promise<ICreateAndEditResult> => {
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
            name: categoryData.name,
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
            },
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

const updateCategory = async (categoryId: string, categoryData: ICategory, userId: string): Promise<ICreateAndEditResult> => {
    try {
        if (!mongoose.isValidObjectId(categoryId) || !mongoose.isValidObjectId(userId)) {
            return {
                success: false,
                error: 'server',
                message: 'Invalid category or user ID format',
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

        const updatedCategory = await Category.findOneAndUpdate(
            { _id: categoryId, userId: userObjectId },
            categoryData,
            { new: true } // Return the updated document
        );

        if (!updatedCategory) {
            return {
                success: false,
                error: 'not_found',
                message: 'Category not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Category updated successfully',
            data: {
                name: updatedCategory.name,
                description: updatedCategory.description,
            },
        };
    } catch (error: any) {
        console.error('Error updating category:', error);

        if (error.code === 11000 && error.codeName === 'DuplicateKey') {
            return {
                success: false,
                error: 'duplicate',
                message: 'Category with this name already exists for this user',
            };
        }

        return {
            success: false,
            error: 'server',
            message: 'An error occurred while updating the category',
        };
    }
};

const deleteCategory = async (categoryId: string, userId: string): Promise<IDeleteResult> => {
    try {
        if (!mongoose.isValidObjectId(categoryId) || !mongoose.isValidObjectId(userId)) {
            return {
                success: false,
                error: 'server',
                message: 'Invalid category or user ID format',
            };
        }

        const userObjectId = new mongoose.Types.ObjectId(userId);

        const existingUser = await User.exists({ _id: userObjectId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const deletedCategory = await Category.findOneAndUpdate(
            {
                _id: categoryId,
                userId: userObjectId,
            },
            {
                deletedAt: new Date(),
            }
        );

        if (!deletedCategory) {
            return {
                success: false,
                error: 'not_found',
                message: 'Category not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Category deleted successfully',
        };
    } catch (error) {
        console.error('Error deleting category:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while deleting the category',
        };
    }
};

export default {
    createCategory,
    updateCategory,
    deleteCategory,
};
