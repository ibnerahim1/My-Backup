using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using TMPro;
using UnityEngine.UI;

public class GemMagnetEffect : MonoBehaviour
{
    public GameObject Gemprefab;
    public GameObject _gemparent;
    public Transform Gemcollector;
    public TextMeshProUGUI gemText;

    public void spawnDiamond(Transform pos, int coinAmount)
    {
        //iOSHapticController.instance.TriggerNotificationSuccess();
        //int coinAmount = Random.Range(1, 4);
        for (int i = 0; i < coinAmount; i++)
        {
            Transform t = Instantiate(Gemprefab.transform, transform.position, Quaternion.identity, _gemparent.transform);
            Vector2 canvasPos;
            Vector2 screenPoint = Camera.main.WorldToScreenPoint(pos.position);
            RectTransformUtility.ScreenPointToLocalPointInRectangle(_gemparent.GetComponent<RectTransform>(), screenPoint, Camera.main, out canvasPos);
            t.localPosition = canvasPos;
            t.transform.localScale = new Vector3(1, 1, 1);
            t.transform.localEulerAngles = Vector3.zero;
            Vector3 randomPos = new Vector3(Random.Range(t.localPosition.x - 100, t.localPosition.x + 100),
                                            Random.Range(t.localPosition.y - 100, t.localPosition.y + 100),
                                            0);
            Sequence seq = DOTween.Sequence();
            seq.Append(t.DOLocalMove(randomPos, Random.Range(.3f, .6f)).SetEase(Ease.OutBack));
            seq.Append(t.DOLocalMove(Gemcollector.localPosition, Random.Range(.3f, .6f)).SetEase(Ease.Linear));
            seq.OnComplete(() =>
            {
                PlayerPrefs.SetInt("cash", PlayerPrefs.GetInt("cash") + 1);
                gemText.text = PlayerPrefs.GetInt("cash").ToString();
                Destroy(t.gameObject);
                Gemcollector.DOPunchScale(new Vector3(.2f, .2f, .2f), .2f);
                Gemcollector.DOScale(new Vector3(1, 1, 1), 0.1f);
            });
        }
    }
}
