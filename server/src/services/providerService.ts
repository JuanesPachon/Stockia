import { ICreateAndEditResult } from '../interfaces/database.interface.js';
import { IProvider } from '../interfaces/models.interface.js';
import Provider from '../models/providerModel.js';
import User from '../models/userModel.js';
import Category from '../models/categoryModel.js';

const createProvider = async (providerData: IProvider, userId: string): Promise<ICreateAndEditResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        const existingProvider = await Provider.exists({
            name: providerData.name,
            userId: userId,
            deletedAt: null,
        });

        if (existingProvider) {
            return {
                success: false,
                error: 'duplicate',
                message: 'Provider already exists',
            };
        }

        if (providerData.categoryId) {
            const existingCategory = await Category.exists({
                _id: providerData.categoryId,
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

        const newProvider = {
            ...providerData,
            userId: userId,
        };

        const createdProvider = await Provider.create(newProvider);

        return {
            success: true,
            message: 'Provider created successfully',
            data: {
                id: createdProvider._id,
                name: createdProvider.name,
                categoryId: createdProvider.categoryId,
                contact: createdProvider.contact,
                description: createdProvider.description,
                status: createdProvider.status,
                createdAt: createdProvider.createdAt,
            },
        };
    } catch (error) {
        console.error('Error creating provider:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while creating the provider',
        };
    }
};

const updateProvider = async (providerId: string, providerData: Partial<IProvider>, userId: string): Promise<ICreateAndEditResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        if (providerData.categoryId) {
            const existingCategory = await Category.exists({
                _id: providerData.categoryId,
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

        if (providerData.name) {
            const existingProvider = await Provider.exists({
                name: providerData.name,
                userId: userId,
                _id: { $ne: providerId },
                deletedAt: null,
            });

            if (existingProvider) {
                return {
                    success: false,
                    error: 'duplicate',
                    message: 'Provider with this name already exists',
                };
            }
        }

        const updatedProvider = await Provider.findOneAndUpdate(
            { _id: providerId, userId: userId, deletedAt: null },
            providerData,
            { new: true }
        );

        if (!updatedProvider) {
            return {
                success: false,
                error: 'not_found',
                message: 'Provider not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Provider updated successfully',
            data: {
                id: updatedProvider._id,
                name: updatedProvider.name,
                categoryId: updatedProvider.categoryId,
                contact: updatedProvider.contact,
                description: updatedProvider.description,
                status: updatedProvider.status,
                createdAt: updatedProvider.createdAt,
            },
        };
    } catch (error) {
        console.error('Error updating provider:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while updating the provider',
        };
    }
};

export default {
    createProvider,
    updateProvider,
};
