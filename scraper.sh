#!/bin/bash

# On définit l'URL de l'Eurostoxx 50 sur Investing.com
EUROSTOXX50_URL="https://www.investing.com/indices/eu-stoxx50"

# Fonction pour récupérer le prix
scrape_index() {
    URL=$1
    NAME="Eurostoxx 50"

    # On télécharge la page HTML en simulant un vrai navigateur
    html=$(curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36" "$URL")

    # On essaie d'extraire le prix avec une nouvelle méthode
    price=$(echo "$html" | grep -oP '(?<="last":)[0-9]+(\.[0-9]+)?' | head -n 1)

    # On vérifie si on a réussi à récupérer le prix
    if [ -z "$price" ]; then
        echo "Erreur : Impossible de récupérer les données pour $NAME"
        echo "Contenu HTML :"
        echo "$html" | head -n 20  # Affiche les 20 premières lignes de l'HTML pour vérifier
    else
        echo "$NAME : $price"
        echo "$(date), $NAME, $price" >> eurostoxx50_data.csv
    fi
}

# Création du fichier CSV s'il n'existe pas
if [ ! -f eurostoxx50_data.csv ]; then
    echo "Date,Index,Price" > eurostoxx50_data.csv
fi

# Scraping de l'Eurostoxx 50
scrape_index "$EUROSTOXX50_URL"
