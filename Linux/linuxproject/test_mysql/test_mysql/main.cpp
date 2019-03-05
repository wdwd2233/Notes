#include <mysql/mysql.h>
#include <stdio.h>
#include <string>

int main()
{
	std::string ip = "127.0.0.1";
	std::string userName = "root";
	std::string passwd = "1234";
	std::string dbName = "casino";

	MYSQL *mysql = mysql_init(NULL);
	if (mysql == NULL)
	{
		printf("error: %s\n", mysql_error(mysql));
		return 1;
	}

	my_bool reconnect = true;
	mysql_options(mysql, MYSQL_OPT_RECONNECT, &reconnect);
	mysql_options(mysql, MYSQL_SET_CHARSET_NAME, "gbk");
	if (!mysql_real_connect(mysql, ip.c_str(), userName.c_str(), passwd.c_str(), dbName.c_str(), 0, NULL, 0))
	{
		printf("error: %s\n", mysql_error(mysql));
		return 1;
	}

	printf("success\n");

	int result = mysql_query(mysql, "select * from acc");
	if (result != 0)
	{
		printf("error: %s\n", mysql_error(mysql));
		return 1;
	}

	MYSQL_RES *mysql_res = mysql_store_result(mysql);
	if (mysql_res != NULL)
	{
		printf("return %llu cols\n", mysql_num_rows(mysql_res));
		MYSQL_FIELD *mysql_field;
		int i = 0;
		while ((mysql_field = mysql_fetch_field(mysql_res)))
		{
			if (i == 5)
				break;
			printf("%s\t", mysql_field->name);
			++i;
		}
		printf("\n");

		MYSQL_ROW mysql_row;
		i = 0;
		while ((mysql_row = mysql_fetch_row(mysql_res)))
		{
			if (i == 10)
				break;
			for (unsigned int i = 0; i < 5; i++)
			{
				printf("%s\t", mysql_row[i] ? mysql_row[i] : "NULL");
			}
			printf("\n");
			++i;
		}
		mysql_free_result(mysql_res);
	}
	mysql_close(mysql);
	return 0;
}