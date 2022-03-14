<template>
  <h1>{{ msg }}</h1>
  <button @click="count++">count is: {{ count }}</button>
  <p>
    Word is: {{ word }}
  </p>
  <p>
    Edit
    <code>components/HelloWorld.vue</code> to test hot module replacement.
  </p>
</template>

<script>
import axios from 'axios';

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      count: 0,
      word: ""
    }
  },
  mounted() {
    axios
      .get("https://catfact.ninja/fact")
      .then(response => {
        this.word = response.data.fact;
      });
  },
}
</script>
