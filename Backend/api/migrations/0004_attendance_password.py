# Generated by Django 4.1.12 on 2023-10-19 18:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_alter_attendance_name'),
    ]

    operations = [
        migrations.AddField(
            model_name='attendance',
            name='password',
            field=models.CharField(max_length=100, null=True),
        ),
    ]
