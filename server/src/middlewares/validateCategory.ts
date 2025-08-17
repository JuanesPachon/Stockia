import { check } from 'express-validator';

export const categoryValidations = [
    check('name')
        .notEmpty()
        .withMessage('Category name is required')
        .isLength({ min: 2, max: 50 })
        .withMessage('Category name must be between 2 and 50 characters')
        .matches(/^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ\s]+$/)
        .withMessage('Category name must contain only letters, numbers, and spaces'),

    check('description')
        .optional()
        .isLength({ max: 200 })
        .withMessage('Description must not exceed 200 characters'),
];
