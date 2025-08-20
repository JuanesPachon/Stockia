import { ICreateAndEditResult } from '../interfaces/database.interface.js';
import { INote } from '../interfaces/models.interface.js';
import Note from '../models/noteModel.js';
import User from '../models/userModel.js';
import Category from '../models/categoryModel.js';

const createNote = async (noteData: INote, userId: string): Promise<ICreateAndEditResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        const existingNote = await Note.exists({
            title: noteData.title,
            userId: userId,
            deletedAt: null,
        });

        if (existingNote) {
            return {
                success: false,
                error: 'duplicate',
                message: 'Note with this title already exists',
            };
        }

        if (noteData.categoryId) {
            const existingCategory = await Category.exists({
                _id: noteData.categoryId,
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

        const newNote = {
            ...noteData,
            userId: userId,
        };

        const createdNote = await Note.create(newNote);

        return {
            success: true,
            message: 'Note created successfully',
            data: {
                id: createdNote._id,
                title: createdNote.title,
                categoryId: createdNote.categoryId,
                description: createdNote.description,
                createdAt: createdNote.createdAt,
            },
        };
    } catch (error) {
        console.error('Error creating note:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while creating the note',
        };
    }
};

const updateNote = async (noteId: string, noteData: Partial<INote>, userId: string): Promise<ICreateAndEditResult> => {
    try {
        const existingUser = await User.exists({ _id: userId });

        if (!existingUser) {
            return {
                success: false,
                message: 'not_found',
            };
        }

        if (noteData.categoryId) {
            const existingCategory = await Category.exists({
                _id: noteData.categoryId,
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

        if (noteData.title) {
            const existingNote = await Note.exists({
                title: noteData.title,
                userId: userId,
                _id: { $ne: noteId },
                deletedAt: null,
            });

            if (existingNote) {
                return {
                    success: false,
                    error: 'duplicate',
                    message: 'Note with this title already exists',
                };
            }
        }

        const updatedNote = await Note.findOneAndUpdate(
            { _id: noteId, userId: userId, deletedAt: null },
            noteData,
            { new: true }
        );

        if (!updatedNote) {
            return {
                success: false,
                error: 'not_found',
                message: 'Note not found or does not belong to the user',
            };
        }

        return {
            success: true,
            message: 'Note updated successfully',
            data: {
                id: updatedNote._id,
                title: updatedNote.title,
                categoryId: updatedNote.categoryId,
                description: updatedNote.description,
                createdAt: updatedNote.createdAt,
            },
        };
    } catch (error) {
        console.error('Error updating note:', error);
        return {
            success: false,
            error: 'server',
            message: 'An error occurred while updating the note',
        };
    }
};

export default {
    createNote,
    updateNote,
};
