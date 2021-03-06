<template>
  <div>
    <v-container>
      <router-link :to="{ name: 'recordsList' }">
        <v-btn>
          {{ "RecordsList" | loc }}
        </v-btn>
      </router-link>
      <AppLoader v-if="loader" />
      <v-form
        v-else
        @submit.prevent="formHandler"
        ref="form"
        v-model="valid"
        lazy-validation
      >
        <v-text-field
          v-model="title"
          :rules="titleRules"
          name="title"
          :label="loc('Title')"
          :hint="loc('AtLeast2Characters')"
          required
        ></v-text-field>

        <v-flex class="d-flex flex-nowrap align-center">
          <v-chip :disabled="income" color="red">{{ "Outcome" | loc }}</v-chip>
          <v-switch v-model="income" class="mx-4"></v-switch>
          <v-chip :disabled="!income" color="success">{{
            "Income" | loc
          }}</v-chip>
        </v-flex>

        <v-select
          :items="categories"
          v-model="categoryId"
          :label="loc('Category')"
          item-text="title"
          item-value="id"
        ></v-select>

        <v-text-field
          v-model="amount"
          :rules="amountRules"
          name="amount"
          type="number"
          :hint="loc('HowMuch')"
          :label="loc('Amount')"
        ></v-text-field>

        <v-btn
          type="submit"
          color="primary"
          :loading="btnLoading"
          class="mr-4 mt-4"
          >{{ "Update" | loc }}</v-btn
        >
      </v-form>
    </v-container>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import mixinParser from "@/mixins/parser";
import AppLoader from "@/components/loader";
import loc from "@/filters/localize";
export default {
  mixins: [mixinParser],
  components: {
    AppLoader,
  },
  data() {
    return {
      loc,
      valid: true,
      loader: true,
      income: false,
      categoryId: false,
      title: "",
      titleRules: [(v) => v.length >= 2 || loc("AtLeast2Characters")],
      amount: "",
      amountRules: [(v) => !!v || loc("AmountRequired")],
      btnLoading: false,
    };
  },
  computed: {
    ...mapGetters("records", ["records"]),
    ...mapGetters("categories", ["categories"]),
  },
  methods: {
    ...mapActions("records", ["load", "loadById", "update"]),
    ...mapActions("categories", { categoriesLoad: "load" }),
    async formHandler() {
      this.title = this.MixinParser(this.title);
      this.$nextTick(async () => {
        if (this.$refs.form.validate()) {
          this.btnLoading = true;

          await this.update({
            id: this.$route.params.id,
            title: this.title,
            income: this.income,
            categoryId: this.categoryId,
            amount: this.amount,
          });

          this.btnLoading = false;
        }
      });
    },
    setupForm(data) {
      this.title = data.title;
      this.amount = data.amount;
      this.income = data.income;
      this.categoryId = data.categoryId;
    },
  },
  async mounted() {
    if (!this.records) {
      await this.load();
    }
    if (!this.categories) {
      await this.categoriesLoad();
    }
    let res = await this.loadById(this.$route.params.id);
    if (res) {
      this.setupForm(res);
      this.loader = false;
    }
  },
};
</script>

