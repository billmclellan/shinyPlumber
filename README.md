# shinyPlumber
plumber api for shiny app - demo for useR group 2020-04-21

Info I depended on preparing for this talk included:
- https://www.data-imaginist.com/2017/introducing-tidygraph/
- https://blog.revolutionanalytics.com/2018/12/azurecontainers.html#more

Use cases for API
- Allow apps or services written in other languages to call your models or app programs written in R
- Expose your models to a native mobile app
- move expensive compute or database transactions out of your code, for example in a shiny app, out of your server.R file, really just meant as lightweight webserver logic, not heavy lifting

Move through files sequentially in this order:

secrets.R
bullring_app/app.R
bullring_api/Plumber.R, Dockerfile, bullring.yaml, azure.R
bullring_shinyPlumber/app.R
