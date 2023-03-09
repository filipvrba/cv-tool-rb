module CVTool
  module Constants
    APP_NAME = 'cvt'
    API_URI = 'http://localhost:8080/api/v1'
    ENDPOINTS = [
      'get/articles',
      'get/projects',
      'get/profiles',

      'post/article/add',
      'post/article/free',
      'post/article/update',

      'post/project/add',
      'post/project/free',
      'post/project/update',

      'post/profile/add',
      'post/profile/free',
      'post/profile/update',

      'post/tables/reset',
    ]
    METHODS = [
      'get',
      'post'
    ]
    SHEMAS = {
      article: [
        'author_id',
        'project_id',
        'name',
        'description',
        'url'
      ],
      project: [
        'author_id',
        'name',
        'category',
        'content'
      ],
      profile: [
        'is_author',
        'full_name',
        'avatar',
        'email',
        'phone',
        'bio'
      ]
    }
    GT_LENGTH = 40
    ENV_NAME = 'CV_TOKEN'
  end
end
