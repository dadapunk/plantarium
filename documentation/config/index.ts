import securityConfig from './security.config.js';
import optimizationConfig from './optimization.config.js';
import analyticsConfig from './analytics.config.js';

export {
  securityConfig,
  optimizationConfig,
  analyticsConfig,
};

// Configuration validation
const validateConfigs = () => {
  // Add validation logic here if needed
  console.log('Configurations loaded successfully');
};

validateConfigs(); 