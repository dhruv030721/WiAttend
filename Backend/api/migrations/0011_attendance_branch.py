# Generated by Django 4.1.12 on 2023-10-22 18:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0010_alter_attendance_date'),
    ]

    operations = [
        migrations.AddField(
            model_name='attendance',
            name='branch',
            field=models.CharField(max_length=10, null=True),
        ),
    ]
