#!/bin/bash

# Vérifier si l'utilisateur a fourni un nom d'utilisateur
if [ -z "$1" ]; then
  echo "Usage: $0 <nom_utilisateur>"
  exit 1
fi

USER=$1

# Vérifier si l'utilisateur existe
if ! id "$USER" &>/dev/null; then
  echo "L'utilisateur '$USER' n'existe pas."
  exit 1
fi

# Afficher l'historique des commandes de l'utilisateur
echo "Historique des commandes de l'utilisateur '$USER':"
history -u "$USER"
echo ""

# Afficher la dernière connexion de l'utilisateur
LAST_LOGIN=$(last -n 1 "$USER" | head -n 1)
if [ -z "$LAST_LOGIN" ]; then
  echo "L'utilisateur '$USER' n'a jamais été connecté."
else
  echo "Dernière connexion de '$USER':"
  echo "$LAST_LOGIN"
fi

# Calculer le nombre de jours depuis la dernière connexion
LAST_LOGIN_DATE=$(last -n 1 "$USER" | head -n 1 | awk '{print $4, $5, $6}')
if [ ! -z "$LAST_LOGIN_DATE" ]; then
  # Convertir la date en format UNIX timestamp
  LAST_LOGIN_TIMESTAMP=$(date -d "$LAST_LOGIN_DATE" +%s)
  CURRENT_TIMESTAMP=$(date +%s)

  # Calculer la différence en jours
  DAYS_SINCE_LAST_LOGIN=$(( (CURRENT_TIMESTAMP - LAST_LOGIN_TIMESTAMP) / 86400 ))

  echo "Nombre de jours écoulés depuis la dernière connexion: $DAYS_SINCE_LAST_LOGIN jours"
fi
