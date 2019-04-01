require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    # 有効な送信
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: '削除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: '削除', count: 0
  end

  test "should show own microposts, following user's microposts and "do
    from_user   = users(:michael)
    to_user     = users(:archer)
    other_user1 = users(:lana)
    other_user2 = users(:john)

    unique_name = to_user.unique_name
    content = "@#{unique_name} test"
    log_in_as(from_user)

    post microposts_path, params: { micropost: { content: content} }

     # 投稿のid取得
    micropost_id = from_user.microposts.first.id

    # 返信元ユーザのフィードに返信の投稿がある
    get root_path
    assert_select "#micropost-#{micropost_id} span.content", text: content

    # 返信先ユーザのフィードに返信の投稿がある
    log_in_as(to_user)
    get root_path
    assert_select "#micropost-#{micropost_id} span.content", text: content

    # 返信元ユーザをフォローしているユーザのフィードに返信の投稿がある
    log_in_as(other_user1)
    get root_path
    assert_select "#micropost-#{micropost_id} span.content", text: content

    # 返信元ユーザをフォローしていないユーザのフィードに返信の投稿がない
    log_in_as(other_user2)
    get root_path
    assert_no_match "micropost-#{micropost_id}", response.body
  end
end
