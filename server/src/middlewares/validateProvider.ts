import { check } from 'express-validator';

export const providerValidations = [
    check('name')
        .notEmpty()
        .withMessage('Provider name is required')
        .isLength({ min: 2, max: 100 })
        .withMessage('Provider name must be between 2 and 100 characters'),

    check('contact')
        .optional()
        .isLength({ max: 100 })
        .withMessage('Contact must not exceed 100 characters'),

    check('description')
        .optional()
        .isLength({ max: 800 })
        .withMessage('Description must not exceed 800 characters'),

    check('categoryId')
        .optional()
        .isMongoId()
        .withMessage('Category ID must be a valid ID'),

    check('status')
        .optional()
        .isBoolean()
        .withMessage('Status must be a boolean value'),
];

export const editProviderValidations = [
    check('name')
        .optional()
        .isLength({ min: 2, max: 100 })
        .withMessage('Provider name must be between 2 and 100 characters'),

    check('contact')
        .optional()
        .isLength({ max: 100 })
        .withMessage('Contact must not exceed 100 characters'),

    check('description')
        .optional()
        .isLength({ max: 800 })
        .withMessage('Description must not exceed 800 characters'),

    check('categoryId')
        .optional()
        .isMongoId()
        .withMessage('Category ID must be a valid ID'),

    check('status')
        .optional()
        .isBoolean()
        .withMessage('Status must be a boolean value'),
];