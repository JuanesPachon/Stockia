import { Request, Response } from 'express';
import noteService from '../services/noteService.js';
import errorHandler from '../utils/errorHandler.js';

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

export {
    createNoteController,
};
