# JSON Templates
Here are templates for *json* files for specific endpoints. If "All" is specified, this template can be used for all entities such as *Article*, *Project* or *Profile*.

- *Article:*
    - **post/article/add**
        ```json
        {
            "author_id": 1,
            "project_id": 0,
            "name": "",
            "description": "",
            "url": ""
        }
        ```

- *Project:*
    - **post/project/add**
        ```json
        {
            "author_id": 1,
            "name": "",
            "category": "",
            "content": ""
        }
        ```
- *Profile:*
    - **post/profile/add**
        ```json
        {
            "is_author": 1,
            "full_name": "",
            "avatar": "",
            "email": "",
            "phone": "",
            "bio": "",
            "password": ""
        }
        ```

- *All:*
    - **post/:name/free**
        ```json
        {
            "id": 0
        }
        ```
    - **post/:name/update**
        ```json
        {
            "id": 0,
            "query": ""
        }
        ```
