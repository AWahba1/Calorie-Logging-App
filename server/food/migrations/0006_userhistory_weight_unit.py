# Generated by Django 4.2 on 2023-04-28 13:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('food', '0005_userhistory_imageurl'),
    ]

    operations = [
        migrations.AddField(
            model_name='userhistory',
            name='weight_unit',
            field=models.CharField(default='g', max_length=2),
        ),
    ]