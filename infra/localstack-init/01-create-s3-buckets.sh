#!/bin/bash

# Fichier: localstack-init/01-create-s3-buckets.sh
# Ce script s'exécute automatiquement au démarrage de LocalStack

echo "🚀 Initialisation des buckets S3..."

# Attendre que LocalStack soit prêt
echo "⏳ Attente de LocalStack..."
until curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "available"'; do
    echo "LocalStack n'est pas encore prêt, attente de 2 secondes..."
    sleep 2
done

echo "✅ LocalStack est prêt !"

# Configuration AWS CLI pour LocalStack
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

# Créer vos buckets (remplacez par vos noms de buckets)
BUCKETS=("lai" "lai-logs" "lai-backup")

for bucket in "${BUCKETS[@]}"; do
    echo "📦 Création du bucket: $bucket"
    aws --endpoint-url=http://localhost:4566 s3 mb "s3://$bucket" || echo "⚠️  Bucket $bucket existe déjà"
    
    # Optionnel: Configurer les politiques CORS
    aws --endpoint-url=http://localhost:4566 s3api put-bucket-cors \
        --bucket "$bucket" \
        --cors-configuration '{
            "CORSRules": [
                {
                    "AllowedOrigins": ["*"],
                    "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
                    "AllowedHeaders": ["*"],
                    "MaxAgeSeconds": 3000
                }
            ]
        }' || echo "⚠️  Impossible de configurer CORS pour $bucket"
done

# Vérifier que les buckets ont été créés
echo "📋 Liste des buckets créés:"
aws --endpoint-url=http://localhost:4566 s3 ls

echo "✅ Initialisation terminée !"