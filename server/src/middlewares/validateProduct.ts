import { check } from 'express-validator';
import mongoose from 'mongoose';

export const productValidations = [
    check('name')
        .notEmpty()
        .withMessage('Product name is required')
        .isLength({ min: 2, max: 100 })
        .withMessage('Product name must be between 2 and 100 characters')
        .matches(/^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ\s\-.,()&]+$/)
        .withMessage('Product name contains invalid characters'),

    check('categoryId')
        .optional({ nullable: true })
        .custom((value) => {
            if (value && !mongoose.Types.ObjectId.isValid(value)) {
                throw new Error('Invalid category');
            }
            return true;
        }),

    check('providerId')
        .optional({ nullable: true })
        .custom((value) => {
            if (value && !mongoose.Types.ObjectId.isValid(value)) {
                throw new Error('Invalid provider');
            }
            return true;
        }),

    check('stock')
        .notEmpty()
        .withMessage('Stock is required')
        .isInt({ min: 0 })
        .withMessage('Stock must be a non-negative integer'),

    check('price')
        .notEmpty()
        .withMessage('Price is required')
        .isFloat({ min: 0 })
        .withMessage('Price must be a non-negative number')
        .custom((value) => {
            if (value && !/^\d+(\.\d{1,2})?$/.test(value.toString())) {
                throw new Error('Price can have at most 2 decimal places');
            }
            return true;
        }),

    check('imageUrl')
        .optional({ nullable: true })
        .isString()
        .withMessage('Image URL must be a string')
];

export const editProductValidations = [
    check('name')
        .optional()
        .isLength({ min: 2, max: 100 })
        .withMessage('Product name must be between 2 and 100 characters')
        .matches(/^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ\s\-.,()&]+$/)
        .withMessage('Product name contains invalid characters'),

    check('categoryId')
        .optional({ nullable: true })
        .custom((value) => {
            if (value && !mongoose.Types.ObjectId.isValid(value)) {
                throw new Error('Invalid category');
            }
            return true;
        }),

    check('providerId')
        .optional({ nullable: true })
        .custom((value) => {
            if (value && !mongoose.Types.ObjectId.isValid(value)) {
                throw new Error('Invalid provider');
            }
            return true;
        }),

    check('stock')
        .optional()
        .isInt({ min: 0 })
        .withMessage('Stock must be a non-negative integer'),

    check('price')
        .optional()
        .isFloat({ min: 0 })
        .withMessage('Price must be a non-negative number')
        .custom((value) => {
            if (value && !/^\d+(\.\d{1,2})?$/.test(value.toString())) {
                throw new Error('Price can have at most 2 decimal places');
            }
            return true;
        }),

    check('imageUrl')
        .optional({ nullable: true })
        .isString()
        .withMessage('Image URL must be a string')
]