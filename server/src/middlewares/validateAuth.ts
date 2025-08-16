import { check } from 'express-validator';

export const userValidations = [
    check('name')
        .notEmpty()
        .withMessage('First name is required')
        .isLength({ min: 2, max: 30 })
        .withMessage('First name must be between 2 and 30 characters')
        .matches(/^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$/)
        .withMessage('First name must contain only letters'),

    check('email')
        .notEmpty()
        .withMessage('Email is required')
        .isEmail()
        .withMessage('Please enter a valid email address')
        .isLength({ max: 100 })
        .withMessage('Email must not exceed 100 characters'),

    check('password')
        .notEmpty()
        .withMessage('Password is required')
        .isLength({ min: 8 })
        .withMessage('Password must be at least 8 characters long')
        .matches(/\d/)
        .withMessage('Password must contain at least one number')
        .matches(/[a-z]/)
        .withMessage('Password must contain at least one lowercase letter')
        .matches(/[A-Z]/)
        .withMessage('Password must contain at least one uppercase letter')
        .matches(/[!@#$%^&*(),.?":{}|<>]/)
        .withMessage('Password must contain at least one special character'),
];
