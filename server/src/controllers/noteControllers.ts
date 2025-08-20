import { Request, Response } from 'express';
import noteService from '../services/noteService.js';
import errorHandler from '../utils/errorHandler.js';

const getNotesController = async (req: Request, res: Response) => {
    try {
        const userId = req.user?.sub;
        const orderQuery = req.query.order;
        const categoryIdQuery = req.query.categoryId;
        
        const order = typeof orderQuery === 'string' ? orderQuery : 'desc';
        const categoryId = typeof categoryIdQuery === 'string' ? categoryIdQuery : undefined;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await noteService.getNotes(userId, order, categoryId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'User not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const getNoteController = async (req: Request, res: Response) => {
    try {
        const noteId = req.params.id;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await noteService.getNoteById(noteId, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Note not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const createNoteController = async (req: Request, res: Response) => {
    try {
        const noteData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await noteService.createNote(noteData, userId);

        if (response.success) {
            return res.status(201).json(response);
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else if (response.message === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'User not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const updateNoteController = async (req: Request, res: Response) => {
    try {
        const noteId = req.params.id;
        const noteData = req.body;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await noteService.updateNote(noteId, noteData, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'duplicate') {
            return res.status(409).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Note not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

const deleteNoteController = async (req: Request, res: Response) => {
    try {
        const noteId = req.params.id;
        const userId = req.user?.sub;

        if (!userId) {
            return errorHandler.handleAuthError(res);
        }

        const response = await noteService.deleteNote(noteId, userId);

        if (response.success) {
            return res.status(200).json(response);
        } else if (response.error === 'not_found') {
            return errorHandler.handleNotFoundError(res, 'Note not found');
        } else {
            return res.status(500).json(response);
        }
    } catch (error) {
        return errorHandler.handleServerError(res);
    }
};

export {
    getNotesController,
    getNoteController,
    createNoteController,
    updateNoteController,
    deleteNoteController,
};
