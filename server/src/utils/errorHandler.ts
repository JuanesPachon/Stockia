import { Response } from 'express';

function handleError(res: Response, statusCode: number, message: { success: boolean; message: string }) {
  res.status(statusCode).json(message);
}

function handleAuthError(res: Response) {
  handleError(res, 403, { success: false, message: "You do not have permission to perform this action" });
}

function handleValidationError(res: Response) {
  handleError(res, 400, { success: false, message: "Invalid input data" });
}

function handleServerError(res: Response) {
  handleError(res, 500, { success: false, message: "The server encountered an error" });
}

function handleNotFoundError(res: Response, message = "Resource not found") {
  handleError(res, 404, { success: false, message: message });
}

function handleDuplicateError(res: Response, message = "The resource already exists") {
  handleError(res, 409, { success: false, message: message });
}

function handleInvalidCredentialsError(res: Response) {
  handleError(res, 401, { success: false, message: "Invalid credentials" });
}

export default {
  handleError,
  handleAuthError,
  handleValidationError,
  handleServerError,
  handleNotFoundError,
  handleDuplicateError,
  handleInvalidCredentialsError
};