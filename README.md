# Karate - API Testing Suite

Suite BDD completa de testing API contra JSONPlaceholder. Incluye tests de usuarios, posts y comentarios con validación de schema, tests negativos, y headers.

## Características

- **Tests de usuarios**: CRUD completo, validación de schema, tests negativos
- **Tests de posts**: Consulta, creación, actualización, eliminación
- **Tests de comentarios**: Filtros, validación de email, schema completo
- **Validación de headers**: Content-Type verification
- **Tests de límites**: IDs inválidos, datos faltantes

## Requisitos

- JDK 21

## Estructura

```
src/test/
├── java/examples/
│   ├── users/UsersRunner.java
│   ├── posts/PostsRunner.java
│   ├── comments/CommentsRunner.java
│   └── AllTestsRunner.java
└── resources/
    ├── karate-config.js
    └── examples/
        ├── users/users.feature
        ├── posts/posts.feature
        └── comments/comments.feature
```

## Ejecución

```powershell
# Ejecutar todos los tests
.\gradlew.bat test

# Ejecutar solo tests de usuarios
.\gradlew.bat test -Dkarate.options="--tags @users"

# Ejecutar tests de smoke
.\gradlew.bat test -Dkarate.options="--tags @smoke"
```

## Reportes

El reporte HTML se genera en: `build/karate-reports/karate-summary.html`

## Endpoints probados

| Endpoint | Métodos | Descripción |
|----------|---------|-------------|
| `/users` | GET, POST | Gestión de usuarios |
| `/posts` | GET, POST, PUT, PATCH, DELETE | Gestión de posts |
| `/comments` | GET | Gestión de comentarios |
