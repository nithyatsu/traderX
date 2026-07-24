extension radius

param environment string

resource traderxApp 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'traderx'
  properties: {
    environment: environment
  }
}

resource ingressConfig 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'ingress-config'
  properties: {
    environment: environment
    application: traderxApp.id
    data: {
      'default.conf.template': {
        value: '''
server {
    listen 8080;
    server_name ${NGINX_HOST};

    location = /health {
        add_header Content-Type text/plain;
        return 200 "ok\n";
    }

    location /db-web/ {
        proxy_pass ${DATABASE_URL};
    }

    location /reference-data/ {
        proxy_pass ${REFERENCE_DATA_URL};
    }

    location /ng-cli-ws {
        proxy_pass ${WEB_FRONTEND_URL}ng-cli-ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /trade-feed/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_pass ${TRADE_FEED_URL};
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /socket.io/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_pass ${TRADE_FEED_URL}socket.io/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /people-service/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Prefix /people-service;
        proxy_pass ${PEOPLE_SERVICE_URL};
    }

    location /account-service/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Prefix /account-service;
        proxy_pass ${ACCOUNT_SERVICE_URL};
    }

    location /position-service/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Prefix /position-service;
        proxy_pass ${POSITION_SERVICE_URL};
    }

    location /trade-service/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Prefix /trade-service;
        proxy_pass ${TRADE_SERVICE_URL};
    }

    location /trade-processor/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Prefix /trade-processor;
        proxy_pass ${TRADE_PROCESSOR_URL};
    }

    location / {
        proxy_pass ${WEB_FRONTEND_URL};
    }
}
'''
      }
    }
  }
}

resource databaseImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'database-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/database-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource referenceDataImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'reference-data-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/reference-data-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource tradeFeedImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'trade-feed-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/trade-feed-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource peopleServiceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'people-service-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/people-service-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource accountServiceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'account-service-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/account-service-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource positionServiceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'position-service-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/position-service-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource tradeProcessorImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'trade-processor-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/trade-processor-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource tradeServiceImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'trade-service-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/trade-service-specfirst?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource webImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'web-front-end-angular-image'
  properties: {
    environment: environment
    application: traderxApp.id
    build: {
      source: 'git::https://github.com/willtsai/traderX.git//templates/web-front-end/angular?ref=f8d5532d8b2bc208ae15d8c11ca7559e1ad5c788'
    }
  }
}

resource databaseContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'database'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'specs/004-containerized-compose-runtime/system/docker-compose.spec.yaml'
    containers: {
      database: {
        image: databaseImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18082
          }
          pg: {
            containerPort: 18083
          }
          http: {
            containerPort: 18084
          }
        }
        env: {
          DATABASE_TCP_PORT: {
            value: '18082'
          }
          DATABASE_PG_PORT: {
            value: '18083'
          }
          DATABASE_WEB_PORT: {
            value: '18084'
          }
          DATABASE_WEB_HOSTNAMES: {
            value: 'localhost,database'
          }
        }
      }
    }
  }
}

resource referenceDataContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'reference-data'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/reference-data-specfirst'
    containers: {
      referenceData: {
        image: referenceDataImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18085
          }
        }
        env: {
          REFERENCE_DATA_SERVICE_PORT: {
            value: '18085'
          }
          CORS_ALLOWED_ORIGINS: {
            value: 'http://localhost:8080'
          }
        }
      }
    }
    connections: {
      database: {
        source: databaseContainer.id
      }
    }
  }
}

resource tradeFeedContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'trade-feed'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/trade-feed-specfirst'
    containers: {
      tradeFeed: {
        image: tradeFeedImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18086
          }
        }
        env: {
          TRADE_FEED_PORT: {
            value: '18086'
          }
          CORS_ALLOWED_ORIGINS: {
            value: 'http://localhost:8080'
          }
        }
      }
    }
  }
}

resource peopleServiceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'people-service'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/people-service-specfirst'
    containers: {
      peopleService: {
        image: peopleServiceImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18089
          }
        }
        env: {
          PEOPLE_SERVICE_PORT: {
            value: '18089'
          }
          CORS_ALLOWED_ORIGINS: {
            value: 'http://localhost:8080'
          }
        }
      }
    }
  }
}

resource accountServiceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'account-service'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/account-service-specfirst/Dockerfile'
    containers: {
      accountService: {
        image: accountServiceImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18088
          }
        }
        env: {
          ACCOUNT_SERVICE_PORT: {
            value: '18088'
          }
          DATABASE_TCP_HOST: {
            value: 'database'
          }
          DATABASE_TCP_PORT: {
            value: '18082'
          }
          PEOPLE_SERVICE_HOST: {
            value: 'people-service'
          }
          CORS_ALLOWED_ORIGINS: {
            value: 'http://localhost:8080'
          }
        }
      }
    }
    connections: {
      database: {
        source: databaseContainer.id
      }
      peopleservice: {
        source: peopleServiceContainer.id
      }
    }
  }
}

resource positionServiceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'position-service'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/position-service-specfirst/Dockerfile'
    containers: {
      positionService: {
        image: positionServiceImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18090
          }
        }
        env: {
          POSITION_SERVICE_PORT: {
            value: '18090'
          }
          DATABASE_TCP_HOST: {
            value: 'database'
          }
          DATABASE_TCP_PORT: {
            value: '18082'
          }
          CORS_ALLOWED_ORIGINS: {
            value: 'http://localhost:8080'
          }
        }
      }
    }
    connections: {
      database: {
        source: databaseContainer.id
      }
    }
  }
}

resource tradeProcessorContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'trade-processor'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/trade-processor-specfirst/Dockerfile'
    containers: {
      tradeProcessor: {
        image: tradeProcessorImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18091
          }
        }
        env: {
          TRADE_PROCESSOR_SERVICE_PORT: {
            value: '18091'
          }
          DATABASE_TCP_HOST: {
            value: 'database'
          }
          DATABASE_TCP_PORT: {
            value: '18082'
          }
          TRADE_FEED_HOST: {
            value: 'trade-feed'
          }
          CORS_ALLOWED_ORIGINS: {
            value: 'http://localhost:8080'
          }
        }
      }
    }
    connections: {
      database: {
        source: databaseContainer.id
      }
      tradefeed: {
        source: tradeFeedContainer.id
      }
    }
  }
}

resource tradeServiceContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'trade-service'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/trade-service-specfirst/Dockerfile'
    containers: {
      tradeService: {
        image: tradeServiceImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18092
          }
        }
        env: {
          TRADING_SERVICE_PORT: {
            value: '18092'
          }
          ACCOUNT_SERVICE_HOST: {
            value: 'account-service'
          }
          REFERENCE_DATA_HOST: {
            value: 'reference-data'
          }
          PEOPLE_SERVICE_HOST: {
            value: 'people-service'
          }
          TRADE_FEED_HOST: {
            value: 'trade-feed'
          }
          CORS_ALLOWED_ORIGINS: {
            value: 'http://localhost:8080'
          }
        }
      }
    }
    connections: {
      accountservice: {
        source: accountServiceContainer.id
      }
      referencedata: {
        source: referenceDataContainer.id
      }
      peopleservice: {
        source: peopleServiceContainer.id
      }
      tradefeed: {
        source: tradeFeedContainer.id
      }
      tradeprocessor: {
        source: tradeProcessorContainer.id
      }
    }
  }
}

resource webContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'web-front-end-angular'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'templates/web-front-end/angular/Dockerfile'
    containers: {
      web: {
        image: webImage.properties.imageReference
        ports: {
          web: {
            containerPort: 18093
          }
        }
        env: {
          WEB_SERVICE_PORT: {
            value: '18093'
          }
        }
      }
    }
    connections: {
      accountservice: {
        source: accountServiceContainer.id
      }
      referencedata: {
        source: referenceDataContainer.id
      }
      tradeservice: {
        source: tradeServiceContainer.id
      }
      positionservice: {
        source: positionServiceContainer.id
      }
      peopleservice: {
        source: peopleServiceContainer.id
      }
      tradefeed: {
        source: tradeFeedContainer.id
      }
    }
  }
}

resource ingressContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'ingress'
  properties: {
    environment: environment
    application: traderxApp.id
    codeReference: 'specs/004-containerized-compose-runtime/system/ingress-nginx.conf.template'
    containers: {
      ingress: {
        image: 'nginx:1.27-alpine'
        ports: {
          web: {
            containerPort: 8080
          }
        }
        env: {
          NGINX_HOST: {
            value: 'localhost'
          }
          DATABASE_URL: {
            value: 'http://database:18084/'
          }
          REFERENCE_DATA_URL: {
            value: 'http://reference-data:18085/'
          }
          TRADE_FEED_URL: {
            value: 'http://trade-feed:18086/'
          }
          PEOPLE_SERVICE_URL: {
            value: 'http://people-service:18089/'
          }
          ACCOUNT_SERVICE_URL: {
            value: 'http://account-service:18088/'
          }
          POSITION_SERVICE_URL: {
            value: 'http://position-service:18090/'
          }
          TRADE_PROCESSOR_URL: {
            value: 'http://trade-processor:18091/'
          }
          TRADE_SERVICE_URL: {
            value: 'http://trade-service:18092/'
          }
          WEB_FRONTEND_URL: {
            value: 'http://web-front-end-angular:18093/'
          }
        }
        volumeMounts: [
          {
            volumeName: 'config'
            mountPath: '/etc/nginx/templates'
          }
        ]
      }
    }
    volumes: {
      config: {
        secretName: ingressConfig.name
      }
    }
    connections: {
      web: {
        source: webContainer.id
      }
      database: {
        source: databaseContainer.id
      }
      referencedata: {
        source: referenceDataContainer.id
      }
      tradefeed: {
        source: tradeFeedContainer.id
      }
      peopleservice: {
        source: peopleServiceContainer.id
      }
      accountservice: {
        source: accountServiceContainer.id
      }
      positionservice: {
        source: positionServiceContainer.id
      }
      tradeprocessor: {
        source: tradeProcessorContainer.id
      }
      tradeservice: {
        source: tradeServiceContainer.id
      }
    }
  }
}

resource ingressRoute 'Radius.Compute/routes@2025-08-01-preview' = {
  name: 'ingress-route'
  properties: {
    environment: environment
    application: traderxApp.id
    rules: [
      {
        matches: [
          { httpPath: '/' }
        ]
        destinationContainer: {
          resourceId: ingressContainer.id
          containerName: 'ingress'
          containerPort: 8080
        }
      }
    ]
  }
}
