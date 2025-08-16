export interface RegisterResult {
    success: boolean;
    error?: 'duplicate' | 'server' | 'validation';
    message?: string;
}