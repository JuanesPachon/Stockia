import { check } from 'express-validator';

export const saleValidations = [
    check('products')
        .isArray({ min: 1 })
        .withMessage('Products array is required and must contain at least one product'),
    
    check('products.*.productId')
        .notEmpty()
        .withMessage('Product ID is required')
        .isMongoId()
        .withMessage('Product ID must be a valid ID'),
    
    check('products.*.quantity')
        .notEmpty()
        .withMessage('Product quantity is required')
        .isInt({ min: 1 })
        .withMessage('Product quantity must be a positive integer'),
    
    check('total')
        .notEmpty()
        .withMessage('Total is required')
        .isFloat({ min: 0 })
        .withMessage('Total must be a non-negative number'),
];
