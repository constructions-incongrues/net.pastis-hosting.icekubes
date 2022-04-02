workspace {

    model {
        ssArgocd = softwareSystem "ArgoCD"
        user = person "User"
        admin = person "Admin"
        keycloak = softwareSystem "Keycloak"
        user -> keycloak "Uses"
        admin -> keycloak "Administrates"
    }

    views {
        systemContext keycloak "Diagram1" {
            include *
            autoLayout
        }

        theme default
    }

}