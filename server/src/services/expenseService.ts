import { ICreateAndEditResult, IDeleteResult, IGetResult } from '../interfaces/database.interface.js';
import { IExpense } from '../interfaces/models.interface.js';
import Expense from '../models/expenseModel.js';
import User from '../models/userModel.js';
import Category from '../models/categoryModel.js';
import Provider from '../models/providerModel.js';

const getExpenses = async (userId: string, order: string = 'desc', categoryId?: string): Promise<IGetResult> => {
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

        const expenses = await Expense.find(filters)
            .sort(sortObject)
            .populate({
                path: 'categoryId',
                select: 'name description'
            })
            .populate({
                path: 'providerId',
                select: 'name contact'
            });

        return {
            success: true,
            message: 'Expenses retrieved successfully',
            data: expenses,
        };
    } catch (error) {
        console.error('Error fetching expenses:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the expenses',
        };
    }
};

const getExpenseById = async (expenseId: string, userId: string): Promise<IGetResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const expense = await Expense.findOne({
            _id: expenseId,
            userId: userId,
            deletedAt: null,
        })
        .populate({
            path: 'categoryId',
            select: 'name description'
        })
        .populate({
            path: 'providerId',
            select: 'name contact'
        });

        if (!expense) {
            return {
                success: false,
                error: 'not_found',
                message: 'Expense not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Expense retrieved successfully',
            data: expense,
        };
    } catch (error) {
        console.error('Error fetching expense:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the expense',
        };
    }
};

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

        if (expenseData.title) {
            const existingExpense = await Expense.exists({
                title: expenseData.title,
                userId: userId,
                _id: { $ne: expenseId },
                deletedAt: null,
            });

            if (existingExpense) {
                return {
                    success: false,
                    error: 'duplicate',
                    message: 'Expense with this title already exists',
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

const deleteExpense = async (expenseId: string, userId: string): Promise<IDeleteResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const deletedExpense = await Expense.findOneAndUpdate(
            {
                _id: expenseId,
                userId: userId,
                deletedAt: null,
            },
            {
                deletedAt: new Date(),
            }
        );

        if (!deletedExpense) {
            return {
                success: false,
                error: 'not_found',
                message: 'Expense not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Expense deleted successfully',
        };
    } catch (error) {
        console.error('Error deleting expense:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while deleting the expense',
        };
    }
};

export default {
    getExpenses,
    getExpenseById,
    createExpense,
    updateExpense,
    deleteExpense,
};
