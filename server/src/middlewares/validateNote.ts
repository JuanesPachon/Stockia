import { check } from 'express-validator';

export const noteValidations = [
    check('title')
        .notEmpty()
        .withMessage('Note title is required')
        .isLength({ min: 2, max: 100 })
        .withMessage('Note title must be between 2 and 100 characters'),

    check('description')
        .notEmpty()
        .withMessage('Note description is required')
        .isLength({ min: 5, max: 1000 })
        .withMessage('Note description must be between 5 and 1000 characters'),

    check('categoryId')
        .optional()
        .isMongoId()
        .withMessage('Category ID must be a valid ID'),
];

export const editNoteValidations = [
    check('title')
        .optional()
        .isLength({ min: 2, max: 100 })
        .withMessage('Note title must be between 2 and 100 characters'),

    check('description')
        .optional()
        .isLength({ min: 5, max: 1000 })
        .withMessage('Note description must be between 5 and 1000 characters'),

    check('categoryId')
        .optional()
        .isMongoId()
        .withMessage('Category ID must be a valid ID'),
];
