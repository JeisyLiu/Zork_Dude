// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '안개의 탑';

  @override
  String get appTitleEn => '미스트 타워';

  @override
  String get taglineShort => '탐험하고, 수집하고, 대화하고, 싸워 잃어버린 진실을 되찾으세요.';

  @override
  String get taglineFull =>
      '당신은 기억이 없는 안개 낀 숲에서 깨어납니다.\n탐험하고, 수집하고, 대화하고, 싸워 잃어버린 진실을 되찾으세요.';

  @override
  String get homeHint => '지휘 탐색 · 안개 지도 · 적과 조우하고 전투에 돌입';

  @override
  String get loading => '로드 중…';

  @override
  String get continueJourney => '여행을 계속하세요';

  @override
  String get enterMist => '안개 속으로 들어가세요';

  @override
  String get achievements => '성취';

  @override
  String get leaderboard => '순위 목록';

  @override
  String get close => '폐쇄';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인하다';

  @override
  String get skip => '뛰어넘다';

  @override
  String get continueAction => '계속하다';

  @override
  String get back => '반품';

  @override
  String get menu => '메뉴';

  @override
  String get startNewJourneyTitle => '새로운 여행을 시작하시나요?';

  @override
  String get overwriteSaveMessage =>
      '이 슬롯에는 이미 진행 상황이 있습니다. 새 게임을 시작하면 이 저장 내용을 덮어쓰게 됩니다. 계속하시겠습니까?';

  @override
  String get overwriteAndStart => '덮고 시작하세요';

  @override
  String get connectPlayGamesTitle => 'Play 게임 연결';

  @override
  String get connectPlayGamesMessage =>
      '업적과 리더보드를 보려면 Google Play 게임즈에 연결하세요. 연결하지 않아도 정상적으로 플레이가 가능합니다.';

  @override
  String get connectLater => '나중에 얘기하자';

  @override
  String get connectNow => '지금 연결하세요';

  @override
  String get returnToTitleTitle => '제목을 반환하시겠습니까?';

  @override
  String get returnToTitleMessage =>
      '현재 진행 상황은 자동으로 저장되었으며 제목 페이지 \"Continue Journey\"에서 복원할 수 있습니다.';

  @override
  String get returnToTitle => '제목 반환';

  @override
  String get quitAppTitle => '게임을 종료하시겠습니까?';

  @override
  String get quitAppMessage => '미스트 타워는 폐쇄됩니다.';

  @override
  String get quit => '그만두다';

  @override
  String get combatPauseTitle => '전투 메뉴 · 일시 정지';

  @override
  String get resumeCombat => '계속 싸워라';

  @override
  String get backToTitle => '제목으로 돌아가기';

  @override
  String get privacySettings => '개인정보 설정';

  @override
  String get privacySettingsHint => '개인정보 설정 · 개인정보 보호';

  @override
  String get rewardOfferTitle => '안개의 선물';

  @override
  String rewardOfferGold(int base, int doubled) {
    return '이 게임의 금화 +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      '선물을 일시적으로 사용할 수 없습니다. 직접 모험을 계속할 수 있습니다.';

  @override
  String get rewardOfferWatch => '광고 시청 · 금화 두 배';

  @override
  String get rewardOfferLoading => '선물 소환...';

  @override
  String get continueAdventure => '모험을 계속하다';

  @override
  String get watchAd => '광고 시청';

  @override
  String get watchAdRecoverLoss => '광고 시청 · 손실 복구';

  @override
  String refundScorePoints(int points) {
    return '$points 포인트 반환';
  }

  @override
  String get summoningGlimmer => '황혼 속에서 소환…';

  @override
  String get glimmerNoResponse => 'Shimmer가 아직 응답하지 않았습니다. 나중에 다시 시도해 주세요.';

  @override
  String get endingDragonTitle => '어린 용이 쓰러졌다';

  @override
  String get endingDragonSubtitle =>
      '마법의 보석이 당신의 손에 떨어졌습니다.\n묘지에서 쉼터로 이어지는 돌문을 열 수 있을 뿐만 아니라, 탑 꼭대기에서 잃어버린 기억을 불러일으킬 수도 있다.';

  @override
  String get endingDragonPrimary => '모험을 계속하다';

  @override
  String get endingDragonSecondary => '여행을 마무리하기 위해 돌아오세요';

  @override
  String get endingMainTitle => '안개가 흩어진다';

  @override
  String get endingMainSubtitle =>
      '기억이 그의 마음 속에 다시 넘쳐났고, 탑의 장벽이 무너졌습니다.\n당신은 자유입니다. 하지만 정신병원 깊숙한 곳에는 아직 끝나지 않은 일이 남아 있습니다.';

  @override
  String get endingMainPrimary => '계속 탐색하세요';

  @override
  String get endingSiteTitle => '사이트 작업 완료';

  @override
  String get endingSiteSubtitle =>
      '최종 프로토타입은 진압되었고 격리실은 침묵에 빠졌습니다.\n긴 여정이 끝나가고 있습니다.';

  @override
  String get endingSitePrimary => '직원 목록 보기';

  @override
  String get endingGameOverTitle => '당신은 떨어졌다';

  @override
  String get endingGameOverSubtitle =>
      '안개가 당신의 모습을 삼켜버립니다.\n마지막으로 탐색한 위치에서 깨어났으며 점수는 -100(0 이상)입니다.';

  @override
  String get endingGameOverPrimary => '마지막 장소에서 일어나';

  @override
  String get inventoryTitle => '배낭 · 재고';

  @override
  String get inventoryUseTitle => '소품 활용 · 활용';

  @override
  String get inventoryDropTitle => '드롭 소품 · 드롭';

  @override
  String get teleportTitle => '보내기 · 텔레포트';

  @override
  String get notLoaded => '아직 로드되지 않음';

  @override
  String get noUsableItems => '사용할 수 있는 소품이 없습니다.';

  @override
  String get noDroppableItems => '버릴 소품이 없습니다.';

  @override
  String get inventoryEmpty => '배낭이 비어 있습니다.';

  @override
  String get noMoreDescription => '더 이상의 설명은 없습니다.';

  @override
  String itemType(String type) {
    return '$type을 입력하세요.';
  }

  @override
  String itemWeight(int weight) {
    return '체중 $weight';
  }

  @override
  String itemValue(int value) {
    return '값 $value';
  }

  @override
  String itemHeal(int heal) {
    return '치료 +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return '공격 +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return '방어 +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return '용량 $capacity';
  }

  @override
  String itemCount(int count) {
    return '수량 x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return '사용 효과: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return '공격+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return '안티+$bonus';
  }

  @override
  String get equip => '장비';

  @override
  String get use => '사용';

  @override
  String get drop => '버리다';

  @override
  String get combatAttack => '공격';

  @override
  String get combatSkill => '기능';

  @override
  String get combatItem => '소품';

  @override
  String get combatDefend => '방어';

  @override
  String get combatMelee => '난투';

  @override
  String get combatFlee => '도망가다';

  @override
  String get combatAttackShort => '공격';

  @override
  String get combatSkillShort => '기술';

  @override
  String get combatItemShort => '도로';

  @override
  String get combatDefendShort => '지키다';

  @override
  String get combatFleeShort => '탈출하다';

  @override
  String get combatCommandsTitle => '명령';

  @override
  String get combatExecute => '구현하다';

  @override
  String get combatVictory => '전투 승리';

  @override
  String get combatVictoryTap => '계속하려면 클릭하세요';

  @override
  String get combatDefeated => '이기다';

  @override
  String get combatLoot => '전리품';

  @override
  String get combatHarvest => '수확하다';

  @override
  String combatGoldGain(int gold) {
    return '💰 금화 +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ 경험 +$exp';
  }

  @override
  String get combatNoItems => '배낭에는 전투용 아이템이 없습니다.';

  @override
  String get combatPickItem => '소품 아이템 선택';

  @override
  String get combatInitiative => '액션 시퀀스 이니셔티브';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return '비트 $index $name 속도 $speed';
  }

  @override
  String get combatLogTitle => '전투 보고 기록';

  @override
  String combatRound(int round) {
    return '라운드 $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return '명령 선택: $name';
  }

  @override
  String get combatPhasePickCommand => '명령 선택';

  @override
  String get combatPhasePickTarget => '대상 선택';

  @override
  String get combatPhasePickItem => '소품과 타겟을 선택하세요';

  @override
  String get combatPhaseReady => '라운드 실행 준비 완료';

  @override
  String get combatPhaseAnimating => '라운드 진행 중…';

  @override
  String get combatQueueTitle => '명령 대기열 명령';

  @override
  String get combatQueuePending => '선정될…';

  @override
  String get combatEnemies => '적 적';

  @override
  String get combatParty => '팀 파티';

  @override
  String get combatTitle => '턴제 전투';

  @override
  String get combatMenuSemantics => '전투 메뉴';

  @override
  String get combatEnded => '전투는 끝났습니다';

  @override
  String get meleeEnded => '근접전이 종료됩니다.';

  @override
  String get meleeCancelled => '근접전이 취소되었습니다.';

  @override
  String get enemyGeneric => '적';

  @override
  String get cmdLook => '확인하다';

  @override
  String get cmdBag => '배낭';

  @override
  String get cmdTalk => '대화';

  @override
  String get cmdHeal => '대하다';

  @override
  String get cmdRecruit => '모집하다';

  @override
  String get cmdParty => '팀';

  @override
  String get cmdScore => '점수';

  @override
  String get cmdHelp => '돕다';

  @override
  String get cmdNgPlus => '두 번째 주';

  @override
  String get cmdMore => '더';

  @override
  String get cmdTake => '찾다';

  @override
  String get cmdBuy => '구입하다';

  @override
  String get cmdSell => '팔다';

  @override
  String get cmdShop => '상품';

  @override
  String get cmdMoreTitle => '더 많은 명령 · 더';

  @override
  String get cmdMoreSemantics => '추가 명령';

  @override
  String get cmdTakeTitle => '픽업 테이크';

  @override
  String get cmdBuyTitle => '구매 구매';

  @override
  String get cmdSellTitle => '팔다 팔다';

  @override
  String get cmdTakeAll => '모두 모두';

  @override
  String get cmdMapOn => '지도';

  @override
  String get cmdMapOff => '지도·관';

  @override
  String get cmdToggleMap => '지도 전환';

  @override
  String get cmdDevMapOn => '전체 사진을 열어보세요';

  @override
  String get cmdDevMapOff => '전체 지도 수준';

  @override
  String get cmdSend => '명령 보내기';

  @override
  String get cmdHint => '명령 cmd: 보기 / 가져가기 1 / n …';

  @override
  String get dirNorth => '노스 N';

  @override
  String get dirWest => '웨스트 여';

  @override
  String get dirEast => '동쪽 E';

  @override
  String get dirSouth => '사우스 S';

  @override
  String get dirUp => '업유';

  @override
  String get dirDown => '넥스트디';

  @override
  String get mapHint => '드래그 앤 팬 · 스크롤 휠/핀치로 확대/축소 · 이동하려면 인접한 노드를 클릭';

  @override
  String mapFullCount(int count) {
    return '전체 이미지 $count';
  }

  @override
  String mapExploredCount(int count) {
    return '$count을(를) 탐색했습니다.';
  }

  @override
  String get mapCannotMoveInCombat => '전투 중에는 이동할 수 없습니다.';

  @override
  String mapGoing(String dir) {
    return '$dir(으)로 이동…';
  }

  @override
  String get mapDevFullMap => 'DEV·전체 그림';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — 인접하지 않고 직접 접근할 수 없음';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name(여기)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · 무게 $weight/$capacity · $count 개 · 💰$gold';
  }

  @override
  String combatUnitSemantics(
    String name,
    int hp,
    int maxHp,
    int atk,
    int def,
    int spd,
  ) {
    return '$name HP $hp/$maxHp 공격 $atk 방어 $def 속도 $spd';
  }

  @override
  String get creditQa => '품질 보증';

  @override
  String get creditPresentedBy => '제작/발표';

  @override
  String get creditDirectedBy => '감독 / 감독';

  @override
  String get creditWrittenBy => '시나리오 작가/작가';

  @override
  String get creditGameDesign => '게임 디자인 / 게임 디자인';

  @override
  String get creditNarrativeDesign => '내러티브 디자인 / 내러티브 디자인';

  @override
  String get creditArtDirection => '아트 디렉션 / 아트 디렉션';

  @override
  String get creditLevelDesign => '레벨 디자인 / 레벨 디자인';

  @override
  String get creditSystemsDesign => '시스템 설계 / 시스템 설계';

  @override
  String get creditCombatDesign => '전투 디자인 / 전투 디자인';

  @override
  String get creditSoundConcept => '사운드 컨셉 / 사운드 컨셉';

  @override
  String get creditProducedBy => '프로듀서 / 제작사';

  @override
  String get creditEngineering => '프로그램 / 엔지니어링';

  @override
  String get creditSpecialThanks => '특별한 감사 / 특별한 감사';

  @override
  String get creditTechSupport => '기술지원 / 기술지원';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsBgmEnabled => '배경 음악';

  @override
  String get settingsSfxEnabled => '효과음';

  @override
  String get settingsGearSemantics => '설정';

  @override
  String get settingsHint => '음량은 기기 음량 버튼으로 조절하세요.';

  @override
  String get settingsMenuLabel => '설정';

  @override
  String get deleteSaveTitle => '저장 데이터를 삭제할까요?';

  @override
  String get deleteSaveMessage => '이 슬롯의 진행 상황이 영구적으로 삭제됩니다.';

  @override
  String get deleteSaveConfirm => '삭제';

  @override
  String get deleteSaveSemantics => '저장 데이터 삭제';
}
