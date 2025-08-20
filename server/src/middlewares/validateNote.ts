import { check } from 'express-validator';

export const noteValidations = [
    check('title')
        .notEmpty()
        .withMessage('Note title is required')
        .isLength({ min: 2, max: 100 })
        .withMessage('Note title must be between 2 and 100 characters')
        .matches(/^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ\s.,-]+$/)
        .withMessage('Note title must contain only letters, numbers, spaces and common punctuation'),

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
