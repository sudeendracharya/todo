from django.db import models

# Create your models here.
class ToDo(models.Model):
    todo = models.CharField(max_length=20)

    def __str__(self):
        return self.todo