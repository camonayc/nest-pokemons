export const EnvConfiguration = () => ({
    environment: process.env.NODE_ENV || 'dev',
    mongodb: process.env.MONGODB,
    port: parseInt(process.env.PORT || '3000', 10),
    defaultLimit: parseInt(process.env.DEFAULT_LIMIT || '10', 10),
})