import { ICreateAndEditResult } from '../interfaces/database.interface.js';
import { IExpense } from '../interfaces/models.interface.js';
import Expense from '../models/expenseModel.js';
import User from '../models/userModel.js';
import Category from '../models/categoryModel.js';
import Provider from '../models/providerModel.js';

const createExpense = async (expenseData: IExpense, userId: string): Promise<ICreateAndEditResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        const existingExpense = await Expense.exists({
            title: expenseData.title,
            userId: userId,
            deletedAt: null,
        });

        if (existingExpense) {
            return {
                success: false,
                error: 'duplicate',
                message: 'Expense with this title already exists',
            };
        }

        if (expenseData.categoryId) {
            const existingCategory = await Category.exists({
                _id: expenseData.categoryId,
                userId: userId,
                deletedAt: null,
            });

            if (!existingCategory) {
                return {
                    success: false,
                    error: 'not_found',
                    message: 'Category not found or does not belong to the user',
                };
            }
        }

        if (expenseData.providerId) {
            const existingProvider = await Provider.exists({
                _id: expenseData.providerId,
                userId: userId,
                deletedAt: null,
            });

            if (!existingProvider) {
                return {
                    success: false,
                    error: 'not_found',
                    message: 'Provider not found or does not belong to the user',
                };
            }
        }

        const newExpense = {
            ...expenseData,
            userId: userId,
        };

        const createdExpense = await Expense.create(newExpense);

        return {
            success: true,
            message: 'Expense created successfully',
            data: {
                id: createdExpense._id,
                title: createdExpense.title,
                amount: createdExpense.amount,
                categoryId: createdExpense.categoryId,
                providerId: createdExpense.providerId,
                description: createdExpense.description,
                createdAt: createdExpense.createdAt,
            },
        };
    } catch (error) {
        console.error('Error creating expense:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while creating the expense',
        };
    }
};

const updateExpense = async (expenseId: string, expenseData: Partial<IExpense>, userId: string): Promise<ICreateAndEditResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        if (expenseData.categoryId) {
            const existingCategory = await Category.exists({
                _id: expenseData.categoryId,
                userId: userId,
                deletedAt: null,
            });

            if (!existingCategory) {
                return {
                    success: false,
                    error: 'not_found',
                    message: 'Category not found or does not belong to the user',
                };
            }
        }

        if (expenseData.providerId) {
            const existingProvider = await Provider.exists({
                _id: expenseData.providerId,
                userId: userId,
                deletedAt: null,
            });

            if (!existingProvider) {
                return {
                    success: false,
                    error: 'not_found',
                    message: 'Provider not found or does not belong to the user',
                };
            }
        }

        const updatedExpense = await Expense.findOneAndUpdate(
            { _id: expenseId, userId: userId, deletedAt: null },
            expenseData,
            { new: true }
        );

        if (!updatedExpense) {
            return {
                success: false,
                error: 'not_found',
                message: 'Expense not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Expense updated successfully',
            data: {
                id: updatedExpense._id,
                title: updatedExpense.title,
                amount: updatedExpense.amount,
                categoryId: updatedExpense.categoryId,
                providerId: updatedExpense.providerId,
                description: updatedExpense.description,
            },
        };
    } catch (error: any) {
        console.error('Error updating expense:', error);

        if (error.code === 11000 && error.codeName === 'DuplicateKey') {
            return {
                success: false,
                error: 'duplicate',
                message: 'Expense with this title already exists',
            };
        }

        return {
            success: false,
            error: 'server',
            message: 'An error occurred while updating the expense',
        };
    }
};

export default {
    createExpense,
    updateExpense,
};
