import { ICreateAndEditResult, IDeleteResult, IGetResult } from '../interfaces/database.interface.js';
import { ICategory } from '../interfaces/models.interface.js';
import Category from '../models/categoryModel.js';
import User from '../models/userModel.js';
import mongoose from 'mongoose';

const getCategories = async (userId: string, order: string = 'desc'): Promise<IGetResult> => {
    try {
        if (!mongoose.isValidObjectId(userId)) {
            return {
                success: false,
                error: 'server',
                message: 'Invalid user',
            };
        }

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

        const categories = await Category.find({ userId: userId, deletedAt: null }).sort(sortObject);

        return {
            success: true,
            message: 'Categories retrieved successfully',
            data: categories,
        };
    } catch (error) {
        console.error('Error fetching categories:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the categories',
        };
    }
};

const getCategoryById = async (categoryId: string, userId: string): Promise<IGetResult> => {
    try {
        if (!mongoose.isValidObjectId(categoryId) || !mongoose.isValidObjectId(userId)) {
            return {
                success: false,
                error: 'server',
                message: 'Invalid category or user',
            };
        }

        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const category = await Category.findOne({
            _id: categoryId,
            userId: userId,
            deleteAt: null,
        });

        if (!category) {
            return {
                success: false,
                error: 'not_found',
                message: 'Category not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Category retrieved successfully',
            data: category,
        };
    } catch (error) {
        console.error('Error fetching category:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the category',
        };
    }
};

const createCategory = async (categoryData: ICategory, userId: string): Promise<ICreateAndEditResult> => {
    try {
        if (!mongoose.isValidObjectId(userId)) {
            return {
                success: false,
                error: 'server',
                message: 'Invalid user',
            };
        }

        const existingUser = await User.exists({ _id: userId });

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
            userId: userId,
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
                message: 'Invalid category or user',
            };
        }

        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        const updatedCategory = await Category.findOneAndUpdate(
            { _id: categoryId, userId: userId },
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
                message: 'Invalid category or user',
            };
        }

        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const deletedCategory = await Category.findOneAndUpdate(
            {
                _id: categoryId,
                userId: userId,
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
    getCategories,
    getCategoryById,
    createCategory,
    updateCategory,
    deleteCategory,
};
