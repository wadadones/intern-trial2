require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

  test "should set the user_id to in_reply_to" do
    # michael(返信元ユーザ)でログイン
    from_user = users(:michael)
    log_in_as(from_user)

    # archer(返信先ユーザ)のunique_name取得
    to_user = users(:archer)
    unique_name = to_user.unique_name

    # 返信の内容
    content = "@#{unique_name} 返信テスト"

    # 返信を投稿
    post microposts_path, params: { micropost: { content: content } }

    # 最新の投稿のin_reply_toが返信相手のユーザIDになっている
    assert_equal to_user.id, Micropost.first.in_reply_to
  end
end
