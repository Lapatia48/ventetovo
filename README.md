# Ventetovo

A Spring MVC web application project.

## Prerequisites

- Java 11 or higher
- Maven 3.6+
- Git (optional, for cloning the repository)

## Project Structure

```
ventetovo/
├── src/
│   └── main/
│       ├── java/
│       │   └── controller/
│       │       └── MainController.java
│       └── webapp/
│           ├── index.jsp
│           └── WEB-INF/
│               ├── web.xml
│               ├── spring/
│               │   ├── dispatcher-servlet.xml
│               │   └── root-context.xml
│               └── views/
│                   └── index.jsp
├── sql/
│   └── script.sql
└── pom.xml
```

## Getting Started

### 1. Build the Project

```bash
mvn clean install
```

This will download all dependencies and compile the project.

### 2. Run the Application

```bash
mvn tomcat7:run
```

The Tomcat server will start on port 8080.

### 3. Access the Application

Open your browser and navigate to:

```
http://localhost:8080/entrer
```

This will display the index view.

## Configuration

- **Server Port**: 8080 (configured in `pom.xml`)
- **Application Context**: Root context `/`
- **Spring Dispatcher Servlet**: Configured in `web.xml`
- **View Resolver**: JSP files located in `/WEB-INF/views/`

## Dependencies

- **Spring Framework 5.3.0** - Core Spring MVC framework
- **Tomcat 7.0.47** - Application server (via Maven plugin)

## Development

### Adding New Controllers

1. Create a new controller class in `src/main/java/controller/`
2. Annotate with `@Controller`
3. Define methods with `@GetMapping` or `@PostMapping` annotations

### Adding New Views

1. Create `.jsp` files in `src/main/webapp/WEB-INF/views/`
2. Return the view name from your controller method
3. The view resolver will automatically append `.jsp` extension

## Troubleshooting

### Port Already in Use

If port 8080 is already in use, you can change it in `pom.xml`:

```xml
<configuration>
    <port>8081</port>
    <path>/</path>
</configuration>
```

### Clean Build Required

If you encounter classloader issues, run:

```bash
mvn clean tomcat7:run
```

## License

This project is part of the ITU course materials.
