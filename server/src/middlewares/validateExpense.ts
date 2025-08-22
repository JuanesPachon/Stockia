import { check } from 'express-validator';

export const expenseValidations = [
    check('title')
        .notEmpty()
        .withMessage('Expense title is required')
        .isLength({ min: 2, max: 100 })
        .withMessage('Expense title must be between 2 and 100 characters')
        .matches(/^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ\s.,-]+$/)
        .withMessage('Expense title must contain only letters, numbers, spaces and common punctuation'),

    check('amount')
        .notEmpty()
        .withMessage('Amount is required')
        .isFloat({ min: 0 })
        .withMessage('Amount must be a non-negative number'),

    check('description')
        .optional()
        .isLength({ max: 1000 })
        .withMessage('Description must not exceed 1000 characters'),

    check('categoryId')
        .optional()
        .isMongoId()
        .withMessage('Category ID must be a valid ID'),

    check('providerId')
        .optional()
        .isMongoId()
        .withMessage('Provider ID must be a valid ID'),
];

export const editExpenseValidations = [
    check('title')
        .optional()
        .isLength({ min: 2, max: 100 })
        .withMessage('Expense title must be between 2 and 100 characters')
        .matches(/^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ\s.,-]+$/)
        .withMessage('Expense title must contain only letters, numbers, spaces and common punctuation'),

    check('amount')
        .optional()
        .isFloat({ min: 0 })
        .withMessage('Amount must be a non-negative number'),

    check('description')
        .optional()
        .isLength({ max: 1000 })
        .withMessage('Description must not exceed 1000 characters'),

    check('categoryId')
        .optional()
        .isMongoId()
        .withMessage('Category ID must be a valid ID'),

    check('providerId')
        .optional()
        .isMongoId()
        .withMessage('Provider ID must be a valid ID'),
];
