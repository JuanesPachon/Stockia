import { ICreateAndEditResult, IDeleteResult, IGetResult } from '../interfaces/database.interface.js';
import { IProvider } from '../interfaces/models.interface.js';
import Provider from '../models/providerModel.js';
import User from '../models/userModel.js';
import Category from '../models/categoryModel.js';

const getProviders = async (userId: string, order: string = 'desc', categoryId?: string): Promise<IGetResult> => {
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

        const providers = await Provider.find(filters)
            .sort(sortObject)
            .populate({
                path: 'categoryId',
                select: 'name description'
            });

        return {
            success: true,
            message: 'Providers retrieved successfully',
            data: providers,
        };
    } catch (error) {
        console.error('Error fetching providers:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the providers',
        };
    }
};

const getProviderById = async (providerId: string, userId: string): Promise<IGetResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const provider = await Provider.findOne({
            _id: providerId,
            userId: userId,
            deletedAt: null,
        })
        .populate({
            path: 'categoryId',
            select: 'name description'
        });

        if (!provider) {
            return {
                success: false,
                error: 'not_found',
                message: 'Provider not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Provider retrieved successfully',
            data: provider,
        };
    } catch (error) {
        console.error('Error fetching provider:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while fetching the provider',
        };
    }
};

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

const deleteProvider = async (providerId: string, userId: string): Promise<IDeleteResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                error: 'not_found',
            };
        }

        const deletedProvider = await Provider.findOneAndUpdate(
            {
                _id: providerId,
                userId: userId,
                deletedAt: null,
            },
            {
                deletedAt: new Date(),
            }
        );

        if (!deletedProvider) {
            return {
                success: false,
                error: 'not_found',
                message: 'Provider not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Provider deleted successfully',
        };
    } catch (error) {
        console.error('Error deleting provider:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while deleting the provider',
        };
    }
};

export default {
    getProviders,
    getProviderById,
    createProvider,
    updateProvider,
    deleteProvider,
};
