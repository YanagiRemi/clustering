clear all;,close all; % すべてのグローバル変数/ウィンドを消去
X=load('sample2d.txt'); % sample2d.txtの読み込み
[d,n]=size(X); % X の次元 d とサンプル数 n を取得
k=7;  %kの値設定

p=[];
R=randperm(n,k);  %1からnの整数からk個ランダムに選んだ行ベクトルR作成
for j=1:k
    p=[p,X(1:2,R(:,j))];  %プロトタイプをサンプルからk個ランダムに選ぶ
end
before=zeros(n,k);    
while(1)
  u=zeros(n,k);  %n行k列の要素0の行列でuを初期化
  for i=1:n
      a=[];
      for j=1:k
          a=[a,(X(1:2,i)-p(:,j))'*(X(1:2,i)-p(:,j))]; %行列aに各プロトタイプとの距離を格納
      end
      [a,I]=sort(a,2);  %aを昇順にソート
      u(i,I(1))=1; %距離が最小のプロトタイプに対応するuの要素を1にする
  end
  for j=1:k
      if(u(:,j)==zeros(n,1))  
      else
         p(:,j)=sum([u(:,j)';u(:,j)'].*X(1:2,:),2)./sum(u(:,j)); %u(:,j)の要素がすべて0ではないときpの値更新
      end
  end
  if(before==u)  %beforeとuの値が一致したらwhile文を抜ける
     break;
  endif
  before=u;  %beforeにuを格納
end

figure(1),clf;
m=['o','x','d','p','^','*','>'];     %プロットする際の記号を要素に格納した行列m作成
for j=1:k
    Y=[];
    for i=1:n
        if(u(i,j)==1)
          Y=[Y,X(1:2,i)];   %プロトタイプに属するXの値をYに追加
        endif
    end
    % サンプルを 2 次元平面に青点でプロット
    figure(1),hold on,plot(Y(1,:),Y(2,:),m(:,j));  %m(:,j)に格納された記号でYをプロット
    figure(1),plot(p(1,j),p(2,j),'ks');  %黒の四角マークでプロトタイプをプロット
end
set(gca,'FontSize',15); %文字のサイズ設定
axis square %図を正方に整形
